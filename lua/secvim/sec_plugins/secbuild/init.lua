--- SecBuild - build and run helpers for the security stacks.
--- Detects CMake, Meson, Make, Cargo, Go, Foundry, and npm projects and runs
--- the build in a scratch terminal split. C/C++ files also get a compile+run
--- menu with optional ASan/UBSan instrumentation.
local M = {}

local function notify(level, msg)
  vim.notify('SecBuild: ' .. msg, level)
end

local function exists(path)
  return vim.uv.fs_stat(path) ~= nil
end

local function readable(path)
  return vim.fn.filereadable(path) == 1
end

local markers = {
  'CMakeLists.txt',
  'meson.build',
  'Makefile',
  'Cargo.toml',
  'go.mod',
  'foundry.toml',
  'package.json',
}

function M.root()
  return vim.fs.root(0, markers) or vim.fn.getcwd()
end

---@param cmd string
---@param cwd string
---@param title? string
local function run_terminal(cmd, cwd, title)
  local buf = vim.api.nvim_create_buf(false, true)
  vim.cmd 'botright split'
  vim.api.nvim_win_set_buf(0, buf)
  local job = vim.fn.jobstart({ vim.o.shell, '-c', cmd }, { term = true, cwd = cwd })
  if job <= 0 then
    notify(vim.log.levels.ERROR, 'failed to start: ' .. cmd)
    return
  end
  vim.bo[buf].bufhidden = 'wipe'
  vim.cmd 'startinsert'
  notify(vim.log.levels.INFO, (title or 'run') .. ': ' .. cmd)
end

local function cmake_build_dir(root)
  for _, dir in ipairs { 'build', 'cmake-build-debug', 'cmake-build-release', 'out' } do
    if exists(root .. '/' .. dir .. '/CMakeCache.txt') then
      return dir
    end
  end
  return 'build'
end

local function package_has_build(root)
  local path = root .. '/package.json'
  if not readable(path) then
    return false
  end
  local ok, lines = pcall(vim.fn.readfile, path)
  if not ok then
    return false
  end
  local decoded, pkg = pcall(vim.json.decode, table.concat(lines, '\n'))
  return decoded and type(pkg) == 'table' and type(pkg.scripts) == 'table' and pkg.scripts.build ~= nil
end

local function cmake_build_type_flag(root, dir)
  local cache = root .. '/' .. dir .. '/CMakeCache.txt'
  if readable(cache) then
    local ok, lines = pcall(vim.fn.readfile, cache)
    if ok then
      for _, line in ipairs(lines) do
        local value = line:match '^CMAKE_BUILD_TYPE:STRING=(.*)$'
        if value and value ~= '' then
          return ''
        end
      end
    end
  end
  return ' -DCMAKE_BUILD_TYPE=Debug'
end

--- Command that builds the project rooted at `root`, or nil.
---@param root string
---@return string|nil
function M.build_command(root)
  if readable(root .. '/CMakeLists.txt') then
    local dir = cmake_build_dir(root)
    return 'cmake -S . -B '
      .. vim.fn.shellescape(dir)
      .. cmake_build_type_flag(root, dir)
      .. ' -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf '
      .. vim.fn.shellescape(dir .. '/compile_commands.json')
      .. ' compile_commands.json && cmake --build '
      .. vim.fn.shellescape(dir)
      .. ' -j'
  end
  if readable(root .. '/meson.build') then
    if exists(root .. '/build/build.ninja') then
      return 'meson compile -C build'
    end
    return 'meson setup build && meson compile -C build'
  end
  if readable(root .. '/Cargo.toml') then
    return 'cargo build'
  end
  if readable(root .. '/go.mod') then
    return 'go build ./...'
  end
  if readable(root .. '/foundry.toml') then
    return 'forge build'
  end
  if package_has_build(root) then
    return 'npm run build'
  end
  if readable(root .. '/Makefile') then
    return 'make -j'
  end
  return nil
end

function M.build()
  local root = M.root()
  local cmd = M.build_command(root)
  if not cmd then
    notify(vim.log.levels.WARN, 'no build system detected in ' .. vim.fn.fnamemodify(root, ':t'))
    return
  end
  run_terminal(cmd, root, 'build')
end

function M.compile_commands()
  local root = M.root()
  if not readable(root .. '/CMakeLists.txt') then
    notify(vim.log.levels.WARN, 'compile_commands.json generation needs CMakeLists.txt')
    return
  end
  local dir = cmake_build_dir(root)
  local cmd = 'cmake -S . -B '
    .. vim.fn.shellescape(dir)
    .. cmake_build_type_flag(root, dir)
    .. ' -DCMAKE_EXPORT_COMPILE_COMMANDS=ON && ln -sf '
    .. vim.fn.shellescape(dir .. '/compile_commands.json')
    .. ' compile_commands.json'
  run_terminal(cmd, root, 'compile_commands')
end

function M.ctest()
  local root = M.root()
  local dir
  for _, candidate in ipairs { 'build', 'cmake-build-debug', 'cmake-build-release', 'out' } do
    if exists(root .. '/' .. candidate .. '/CTestTestfile.cmake') then
      dir = candidate
      break
    end
  end
  if not dir then
    notify(vim.log.levels.WARN, 'no CTest build directory found (configure with CMake first)')
    return
  end
  run_terminal('ctest --test-dir ' .. vim.fn.shellescape(dir) .. ' --output-on-failure', root, 'ctest')
end

local function compiler_for(ft)
  local candidates
  if ft == 'cpp' then
    candidates = { 'clang++', 'c++', 'g++' }
  else
    candidates = { 'clang', 'cc', 'gcc' }
  end
  for _, candidate in ipairs(candidates) do
    if vim.fn.executable(candidate) == 1 then
      return candidate
    end
  end
  return nil
end

--- Command that compiles (and optionally runs) the current C/C++ file.
---@param file string
---@param ft string
---@param opts? { sanitize?: boolean, build_only?: boolean }
---@return string|nil
function M.run_command(file, ft, opts)
  opts = opts or {}
  if ft ~= 'c' and ft ~= 'cpp' then
    return nil
  end
  local compiler = compiler_for(ft)
  if not compiler then
    return nil
  end

  local out_dir = vim.fn.stdpath 'cache' .. '/secbuild'
  vim.fn.mkdir(out_dir, 'p')
  local out = out_dir .. '/' .. vim.fn.fnamemodify(file, ':t:r')

  local parts = { compiler, '-g', '-O0', '-Wall', '-Wextra' }
  if opts.sanitize then
    vim.list_extend(parts, { '-fsanitize=address,undefined', '-fno-omit-frame-pointer' })
  end
  vim.list_extend(parts, { vim.fn.shellescape(file), '-o', vim.fn.shellescape(out), '-lm' })
  local cmd = table.concat(parts, ' ')
  if not opts.build_only then
    cmd = cmd .. ' && ' .. vim.fn.shellescape(out)
  end
  return cmd
end

---@param opts? { sanitize?: boolean, build_only?: boolean }
function M.run_cpp(opts)
  local file = vim.api.nvim_buf_get_name(0)
  local ft = vim.bo.filetype
  if file == '' or vim.bo.buftype ~= '' then
    notify(vim.log.levels.WARN, 'open a C or C++ source file first')
    return
  end
  local cmd = M.run_command(file, ft, opts)
  if not cmd then
    notify(vim.log.levels.WARN, 'not a C/C++ buffer, or no compiler found')
    return
  end
  local title = opts and opts.sanitize and 'run (ASan/UBSan)' or 'run'
  if opts and opts.build_only then
    title = 'compile'
  end
  run_terminal(cmd, vim.fn.getcwd(), title)
end

function M.run_menu()
  local ft = vim.bo.filetype
  if ft ~= 'c' and ft ~= 'cpp' then
    notify(vim.log.levels.WARN, 'open a C or C++ source file first')
    return
  end
  local items = {
    { label = 'Run (plain)', opts = {} },
    { label = 'Run with ASan + UBSan', opts = { sanitize = true } },
    { label = 'Compile only', opts = { build_only = true } },
  }
  vim.ui.select(
    vim.tbl_map(function(item)
      return item.label
    end, items),
    { prompt = 'SecBuild: C/C++' },
    function(choice)
      for _, item in ipairs(items) do
        if item.label == choice then
          M.run_cpp(item.opts)
          return
        end
      end
    end
  )
end

function M.menu()
  local items = {
    { label = 'Build project', fn = M.build },
    {
      label = 'Run current C/C++ file',
      fn = function()
        M.run_cpp {}
      end,
    },
    {
      label = 'Run current C/C++ file (ASan + UBSan)',
      fn = function()
        M.run_cpp { sanitize = true }
      end,
    },
    { label = 'Generate compile_commands.json', fn = M.compile_commands },
    { label = 'Run CTest', fn = M.ctest },
  }
  vim.ui.select(
    vim.tbl_map(function(item)
      return item.label
    end, items),
    { prompt = 'SecBuild' },
    function(choice)
      for _, item in ipairs(items) do
        if item.label == choice then
          item.fn()
          return
        end
      end
    end
  )
end

return M
