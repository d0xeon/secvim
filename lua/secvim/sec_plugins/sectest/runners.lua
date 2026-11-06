--- Runner definitions for each test framework
--- Each runner defines: detect(), cmd_file(file), cmd_nearest(file, line), cmd_all(), parse(output)

local M = {}

--- @class SecTestResult
--- @field name string
--- @field status "passed"|"failed"|"skipped"
--- @field output string[]

--- @class SecTestSummary
--- @field passed number
--- @field failed number
--- @field skipped number
--- @field total number
--- @field results SecTestResult[]
--- @field raw_output string[]

local function lines(str)
  local result = {}
  for line in str:gmatch '[^\r\n]+' do
    table.insert(result, line)
  end
  return result
end

-- ── Go (go test -v / gotestsum) ──────────────────────────────────────

M.go = {
  detect = function()
    return vim.fn.glob 'go.mod' ~= '' or vim.fn.glob 'go.sum' ~= ''
  end,
  cmd_file = function(file)
    local dir = vim.fn.fnamemodify(file, ':h')
    return { 'go', 'test', '-v', '-count=1', './' .. dir .. '/...' }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'func%s+(Test%w+)'
      if match then
        test_name = match
        break
      end
    end
    local dir = vim.fn.fnamemodify(file, ':h')
    if test_name then
      return { 'go', 'test', '-v', '-count=1', '-run', '^' .. test_name .. '$', './' .. dir .. '/...' }
    end
    return { 'go', 'test', '-v', '-count=1', './' .. dir .. '/...' }
  end,
  cmd_all = function()
    return { 'go', 'test', '-v', '-count=1', './...' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local status, name = line:match '%-%-%-% (%u+):%s+(.+)%s+%('
      if status and name then
        local s = status == 'PASS' and 'passed' or status == 'FAIL' and 'failed' or 'skipped'
        if s == 'passed' then
          passed = passed + 1
        elseif s == 'failed' then
          failed = failed + 1
        else
          skipped = skipped + 1
        end
        table.insert(results, { name = name, status = s, output = {} })
      end
      local skip_name = line:match '%-%-%-% SKIP:%s+(.+)%s+%('
      if skip_name then
        skipped = skipped + 1
        table.insert(results, { name = skip_name, status = 'skipped', output = {} })
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Jest ─────────────────────────────────────────────────────────────

M.jest = {
  detect = function()
    return vim.fn.filereadable 'jest.config.ts' == 1 or vim.fn.filereadable 'jest.config.js' == 1 or vim.fn.filereadable 'jest.config.mjs' == 1
  end,
  cmd_file = function(file)
    return { 'npx', 'jest', '--no-coverage', '--verbose', '--forceExit', file }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match '[it|test|describe]%(%s*[\'"](.+)[\'"]'
      if match then
        test_name = match
        break
      end
    end
    if test_name then
      return { 'npx', 'jest', '--no-coverage', '--verbose', '--forceExit', '-t', test_name, file }
    end
    return { 'npx', 'jest', '--no-coverage', '--verbose', '--forceExit', file }
  end,
  cmd_all = function()
    return { 'npx', 'jest', '--no-coverage', '--verbose', '--forceExit' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local p_name = line:match '✓%s+(.+)%s+%(' or line:match '√%s+(.+)%s+%(' or line:match 'PASS%s+(.+)'
      local f_name = line:match '✕%s+(.+)' or line:match '✗%s+(.+)' or line:match '×%s+(.+)'
      local s_name = line:match '○%s+skipped%s+(.+)'

      if f_name then
        failed = failed + 1
        table.insert(results, { name = vim.trim(f_name), status = 'failed', output = {} })
      elseif s_name then
        skipped = skipped + 1
        table.insert(results, { name = vim.trim(s_name), status = 'skipped', output = {} })
      elseif p_name and line:match '✓' then
        passed = passed + 1
        table.insert(results, { name = vim.trim(p_name), status = 'passed', output = {} })
      end
    end
    -- fallback: parse summary line
    if passed == 0 and failed == 0 then
      local p = output:match 'Tests:%s+(%d+) passed' or '0'
      local f = output:match '(%d+) failed' or '0'
      passed = tonumber(p) or 0
      failed = tonumber(f) or 0
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Vitest ───────────────────────────────────────────────────────────

M.vitest = {
  detect = function()
    return vim.fn.filereadable 'vitest.config.ts' == 1
      or vim.fn.filereadable 'vitest.config.js' == 1
      or vim.fn.filereadable 'vitest.config.mts' == 1
      or (vim.fn.filereadable 'vite.config.ts' == 1 and vim.fn.glob '**/*.test.ts' ~= '')
  end,
  cmd_file = function(file)
    return { 'npx', 'vitest', 'run', '--reporter=verbose', file }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match '[it|test|describe]%(%s*[\'"](.+)[\'"]'
      if match then
        test_name = match
        break
      end
    end
    if test_name then
      return { 'npx', 'vitest', 'run', '--reporter=verbose', '-t', test_name, file }
    end
    return { 'npx', 'vitest', 'run', '--reporter=verbose', file }
  end,
  cmd_all = function()
    return { 'npx', 'vitest', 'run', '--reporter=verbose' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local p_name = line:match '✓%s+(.+)' or line:match '√%s+(.+)'
      local f_name = line:match '×%s+(.+)' or line:match '✗%s+(.+)'
      local s_name = line:match '↓%s+(.+)'

      if f_name then
        failed = failed + 1
        table.insert(results, { name = vim.trim(f_name), status = 'failed', output = {} })
      elseif s_name then
        skipped = skipped + 1
        table.insert(results, { name = vim.trim(s_name), status = 'skipped', output = {} })
      elseif p_name then
        passed = passed + 1
        table.insert(results, { name = vim.trim(p_name), status = 'passed', output = {} })
      end
    end
    if passed == 0 and failed == 0 then
      local p = output:match 'Tests%s+(%d+) passed' or '0'
      local f = output:match '(%d+) failed' or '0'
      passed = tonumber(p) or 0
      failed = tonumber(f) or 0
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Pytest ───────────────────────────────────────────────────────────

local function python_bin()
  local env = vim.env.VIRTUAL_ENV
  if env and env ~= '' then
    local p = env .. '/bin/python'
    if vim.fn.executable(p) == 1 then
      return p
    end
  end
  for _, rel in ipairs { '.venv/bin/python', 'venv/bin/python', '.env/bin/python' } do
    if vim.fn.filereadable(rel) == 1 then
      return vim.fn.fnamemodify(rel, ':p')
    end
  end
  return vim.fn.executable 'python3' == 1 and 'python3' or 'python'
end

M.pytest = {
  detect = function()
    return vim.fn.filereadable 'pytest.ini' == 1
      or vim.fn.filereadable 'pyproject.toml' == 1
      or vim.fn.filereadable 'setup.py' == 1
      or vim.fn.filereadable 'setup.cfg' == 1
      or vim.fn.glob '**/test_*.py' ~= ''
      or vim.fn.glob '**/*_test.py' ~= ''
  end,
  cmd_file = function(file)
    return { python_bin(), '-m', 'pytest', '-v', '--tb=short', '--no-header', file }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'def%s+(test_%w+)' or buf_lines[i]:match 'class%s+(Test%w+)'
      if match then
        test_name = match
        break
      end
    end
    local python = python_bin()
    if test_name then
      return { python, '-m', 'pytest', '-v', '--tb=short', '--no-header', '-k', test_name, file }
    end
    return { python, '-m', 'pytest', '-v', '--tb=short', '--no-header', file }
  end,
  cmd_all = function()
    return { python_bin(), '-m', 'pytest', '-v', '--tb=short', '--no-header' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local name_p = line:match '(.+)%s+PASSED'
      local name_f = line:match '(.+)%s+FAILED'
      local name_s = line:match '(.+)%s+SKIPPED'

      if name_f then
        failed = failed + 1
        table.insert(results, { name = vim.trim(name_f), status = 'failed', output = {} })
      elseif name_s then
        skipped = skipped + 1
        table.insert(results, { name = vim.trim(name_s), status = 'skipped', output = {} })
      elseif name_p then
        passed = passed + 1
        table.insert(results, { name = vim.trim(name_p), status = 'passed', output = {} })
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Pest (PHP) ───────────────────────────────────────────────────────

M.pest = {
  detect = function()
    return vim.fn.filereadable 'vendor/bin/pest' == 1
  end,
  cmd_file = function(file)
    return { 'vendor/bin/pest', '--colors=never', file }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match '[it|test]%(%s*[\'"](.+)[\'"]'
      if match then
        test_name = match
        break
      end
    end
    if test_name then
      return { 'vendor/bin/pest', '--colors=never', '--filter', test_name, file }
    end
    return { 'vendor/bin/pest', '--colors=never', file }
  end,
  cmd_all = function()
    return { 'vendor/bin/pest', '--colors=never' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local p_name = line:match '✓%s+(.+)' or line:match 'PASS%s+(.+)'
      local f_name = line:match '✕%s+(.+)' or line:match 'FAIL%s+(.+)'
      local s_name = line:match '→%s+(.+)' or line:match 'SKIP%s+(.+)'

      if f_name then
        failed = failed + 1
        table.insert(results, { name = vim.trim(f_name), status = 'failed', output = {} })
      elseif s_name then
        skipped = skipped + 1
        table.insert(results, { name = vim.trim(s_name), status = 'skipped', output = {} })
      elseif p_name then
        passed = passed + 1
        table.insert(results, { name = vim.trim(p_name), status = 'passed', output = {} })
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── PHPUnit ──────────────────────────────────────────────────────────

M.phpunit = {
  detect = function()
    return vim.fn.filereadable 'vendor/bin/phpunit' == 1 or vim.fn.filereadable 'phpunit.xml' == 1
  end,
  cmd_file = function(file)
    return { 'vendor/bin/phpunit', '--colors=never', file }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'function%s+(test%w+)'
      if match then
        test_name = match
        break
      end
    end
    if test_name then
      return { 'vendor/bin/phpunit', '--colors=never', '--filter', test_name, file }
    end
    return { 'vendor/bin/phpunit', '--colors=never', file }
  end,
  cmd_all = function()
    return { 'vendor/bin/phpunit', '--colors=never' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    local p = output:match 'OK %((%d+) test' or '0'
    local f = output:match 'Failures: (%d+)' or '0'
    local e = output:match 'Errors: (%d+)' or '0'
    passed = tonumber(p) or 0
    failed = (tonumber(f) or 0) + (tonumber(e) or 0)
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Java (Gradle) ────────────────────────────────────────────────────

M.java = {
  detect = function()
    return vim.fn.filereadable 'build.gradle' == 1 or vim.fn.filereadable 'build.gradle.kts' == 1 or vim.fn.filereadable 'pom.xml' == 1
  end,
  cmd_file = function(file)
    local class_name = vim.fn.fnamemodify(file, ':t:r')
    if vim.fn.filereadable 'build.gradle' == 1 or vim.fn.filereadable 'build.gradle.kts' == 1 then
      return { './gradlew', 'test', '--tests', '*' .. class_name, '--info' }
    end
    return { 'mvn', 'test', '-Dtest=' .. class_name }
  end,
  cmd_nearest = function(file, line)
    local class_name = vim.fn.fnamemodify(file, ':t:r')
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'void%s+(%w+)%s*%(' or buf_lines[i]:match 'fun%s+(%w+)%s*%('
      if match then
        test_name = match
        break
      end
    end
    if vim.fn.filereadable 'build.gradle' == 1 or vim.fn.filereadable 'build.gradle.kts' == 1 then
      if test_name then
        return { './gradlew', 'test', '--tests', '*' .. class_name .. '.' .. test_name, '--info' }
      end
      return { './gradlew', 'test', '--tests', '*' .. class_name, '--info' }
    end
    if test_name then
      return { 'mvn', 'test', '-Dtest=' .. class_name .. '#' .. test_name }
    end
    return { 'mvn', 'test', '-Dtest=' .. class_name }
  end,
  cmd_all = function()
    if vim.fn.filereadable 'build.gradle' == 1 or vim.fn.filereadable 'build.gradle.kts' == 1 then
      return { './gradlew', 'test', '--info' }
    end
    return { 'mvn', 'test' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      -- Gradle test output
      local name_p = line:match '(.+)%s+PASSED'
      local name_f = line:match '(.+)%s+FAILED'
      local name_s = line:match '(.+)%s+SKIPPED'

      if name_f then
        failed = failed + 1
        table.insert(results, { name = vim.trim(name_f), status = 'failed', output = {} })
      elseif name_s then
        skipped = skipped + 1
        table.insert(results, { name = vim.trim(name_s), status = 'skipped', output = {} })
      elseif name_p then
        passed = passed + 1
        table.insert(results, { name = vim.trim(name_p), status = 'passed', output = {} })
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Rust (cargo test) ────────────────────────────────────────────────

M.rust = {
  detect = function()
    return vim.fn.filereadable 'Cargo.toml' == 1
  end,
  cmd_file = function()
    return { 'cargo', 'test', '--', '--nocapture' }
  end,
  cmd_nearest = function(_, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local fn_name = buf_lines[i]:match 'fn%s+([%w_]+)%s*%('
      if fn_name then
        local j = i - 1
        while j >= 1 and buf_lines[j]:match '^%s*$' do
          j = j - 1
        end
        if j >= 1 and buf_lines[j]:match '^%s*#%[.*test.*%]' then
          test_name = fn_name
          break
        end
      end
    end
    if test_name then
      return { 'cargo', 'test', test_name, '--', '--nocapture' }
    end
    return { 'cargo', 'test', '--', '--nocapture' }
  end,
  cmd_all = function()
    return { 'cargo', 'test', '--workspace', '--', '--nocapture' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local name_ok = line:match '^test%s+([%w_:%-]+)%s+%.%.%.%s+ok'
      local name_fail = line:match '^test%s+([%w_:%-]+)%s+%.%.%.%s+FAILED'
      local name_skip = line:match '^test%s+([%w_:%-]+)%s+%.%.%.%s+ignored'
      if name_fail then
        failed = failed + 1
        table.insert(results, { name = name_fail, status = 'failed', output = {} })
      elseif name_skip then
        skipped = skipped + 1
        table.insert(results, { name = name_skip, status = 'skipped', output = {} })
      elseif name_ok then
        passed = passed + 1
        table.insert(results, { name = name_ok, status = 'passed', output = {} })
      end
    end
    if passed == 0 and failed == 0 then
      passed = tonumber(output:match '(%d+) passed') or 0
      failed = tonumber(output:match '(%d+) failed') or 0
      skipped = tonumber(output:match '(%d+) ignored') or 0
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── Solidity (Foundry) ───────────────────────────────────────────────

M.solidity = {
  detect = function()
    return vim.fn.filereadable 'foundry.toml' == 1
  end,
  cmd_file = function(file)
    return { 'forge', 'test', '--color', 'never', '--match-path', file, '-vvv' }
  end,
  cmd_nearest = function(file, line)
    local test_name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'function%s+(test[%w_]*)%s*%(' or buf_lines[i]:match 'function%s+(invariant[%w_]*)%s*%('
      if match then
        test_name = match
        break
      end
    end
    if test_name then
      return { 'forge', 'test', '--color', 'never', '--match-test', '^' .. test_name .. '$', '-vvv' }
    end
    return { 'forge', 'test', '--color', 'never', '--match-path', file, '-vvv' }
  end,
  cmd_all = function()
    return { 'forge', 'test', '--color', 'never', '-vvv' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local status, name = line:match '^%s*%[(%u+)[^%]]*%]%s+([%w_]+)%s*%('
      if status and name then
        local s = status == 'PASS' and 'passed' or status == 'SKIP' and 'skipped' or 'failed'
        if s == 'passed' then
          passed = passed + 1
        elseif s == 'failed' then
          failed = failed + 1
        else
          skipped = skipped + 1
        end
        table.insert(results, { name = name, status = s, output = {} })
      end
    end
    if #results == 0 then
      for _, line in ipairs(lines(output)) do
        local p, f, s = line:match '(%d+) passed;%s*(%d+) failed;%s*(%d+) skipped'
        if p then
          passed = passed + tonumber(p)
          failed = failed + tonumber(f)
          skipped = skipped + tonumber(s)
        end
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

-- ── C/C++ (CTest) ────────────────────────────────────────────────────

local function find_ctest(prefix)
  local base = prefix and (prefix .. '/') or ''
  for _, dir in ipairs { 'build', 'cmake-build-debug', 'cmake-build-release', 'out' } do
    if vim.fn.filereadable(base .. dir .. '/CTestTestfile.cmake') == 1 then
      return base .. dir
    end
  end
  if vim.fn.filereadable(base .. 'CTestTestfile.cmake') == 1 then
    return prefix or '.'
  end
  return nil
end

local function ctest_dir()
  local local_dir = find_ctest(nil)
  if local_dir then
    return local_dir
  end
  local root = vim.fs.root(0, { 'CMakeLists.txt', 'CTestTestfile.cmake' })
  if root then
    return find_ctest(root)
  end
  return nil
end

--- Test names declared in a buffer (GoogleTest, Catch2).
local function buffer_test_names()
  local names = {}
  local seen = {}
  for _, line in ipairs(vim.api.nvim_buf_get_lines(0, 0, -1, false)) do
    local name = line:match 'TEST_?[FP]?%(%s*[%w_]+%s*,%s*([%w_]+)%s*%)'
      or line:match 'TYPED_TEST%s*%(%s*[%w_]+%s*,%s*([%w_]+)%s*%)'
      or line:match 'TEST_CASE%s*%(%s*"([^"]+)"'
      or line:match 'SCENARIO%s*%(%s*"([^"]+)"'
    if name and not seen[name] then
      seen[name] = true
      names[#names + 1] = name
    end
  end
  return names
end

M.ctest = {
  detect = function()
    return ctest_dir() ~= nil
  end,
  cmd_file = function()
    local names = buffer_test_names()
    local args = { 'ctest', '--test-dir', ctest_dir(), '--output-on-failure' }
    if #names > 0 then
      vim.list_extend(args, { '-R', table.concat(names, '|') })
    end
    return args
  end,
  cmd_nearest = function(_, line)
    local name = nil
    local buf_lines = vim.api.nvim_buf_get_lines(0, 0, line, false)
    for i = #buf_lines, 1, -1 do
      local match = buf_lines[i]:match 'TEST_?[FP]?%(%s*[%w_]+%s*,%s*([%w_]+)%s*%)'
        or buf_lines[i]:match 'TYPED_TEST%s*%(%s*[%w_]+%s*,%s*([%w_]+)%s*%)'
        or buf_lines[i]:match 'TEST_CASE%s*%(%s*"([^"]+)"'
        or buf_lines[i]:match 'SCENARIO%s*%(%s*"([^"]+)"'
      if match then
        name = match
        break
      end
    end
    local args = { 'ctest', '--test-dir', ctest_dir(), '--output-on-failure' }
    if name then
      vim.list_extend(args, { '-R', name })
    end
    return args
  end,
  cmd_all = function()
    return { 'ctest', '--test-dir', ctest_dir(), '--output-on-failure' }
  end,
  parse = function(output)
    local results = {}
    local passed, failed, skipped = 0, 0, 0
    for _, line in ipairs(lines(output)) do
      local body = line:match 'Test%s+#%d+:%s+(.+)'
      if body then
        local name, tail = body:match '^(.-)%s+%.+%s*(.+)$'
        if name and tail then
          local lower = tail:lower()
          local status
          if lower:find('passed', 1, true) then
            status = 'passed'
            passed = passed + 1
          elseif lower:find('failed', 1, true) or lower:find('segfault', 1, true) or lower:find('timeout', 1, true) or lower:find('exception', 1, true) then
            status = 'failed'
            failed = failed + 1
          elseif lower:find('skipped', 1, true) or lower:find('not run', 1, true) then
            status = 'skipped'
            skipped = skipped + 1
          end
          if status then
            table.insert(results, { name = vim.trim(name), status = status, output = {} })
          end
        end
      end
    end
    if #results == 0 then
      local pct, f, total = output:match '(%d+)%% tests passed, (%d+) tests failed out of (%d+)'
      if pct and f and total then
        failed = tonumber(f) or 0
        passed = (tonumber(total) or 0) - failed
      end
    end
    return {
      passed = passed,
      failed = failed,
      skipped = skipped,
      total = passed + failed + skipped,
      results = results,
      raw_output = lines(output),
    }
  end,
}

--- Detect the appropriate runner for the current project/file
--- @param filetype string|nil
--- @return table|nil runner, string|nil name

local function makefile_has_test()
  local ok, lines = pcall(vim.fn.readfile, 'Makefile')
  if not ok then
    return false
  end
  for _, line in ipairs(lines) do
    if line:match '^test%s*:' then
      return true
    end
  end
  return false
end

M.make_test = {
  detect = function()
    return makefile_has_test()
  end,
  cmd_file = function()
    return { 'make', 'test' }
  end,
  cmd_nearest = function()
    return { 'make', 'test' }
  end,
  cmd_all = function()
    return { 'make', 'test' }
  end,
  parse = function(output)
    return {
      passed = 0,
      failed = 0,
      skipped = 0,
      total = 0,
      results = {},
      raw_output = lines(output),
    }
  end,
}

function M.detect(filetype)
  -- Priority order based on filetype
  local ft_map = {
    go = { 'go' },
    rust = { 'rust' },
    python = { 'pytest' },
    solidity = { 'solidity' },
    c = { 'ctest', 'make_test' },
    cpp = { 'ctest', 'make_test' },
    php = { 'pest', 'phpunit' },
    java = { 'java' },
    javascript = { 'vitest', 'jest' },
    typescript = { 'vitest', 'jest' },
    typescriptreact = { 'vitest', 'jest' },
    javascriptreact = { 'vitest', 'jest' },
  }

  local candidates = ft_map[filetype] or { 'go', 'rust', 'vitest', 'jest', 'pytest', 'ctest', 'make_test', 'solidity', 'pest', 'phpunit', 'java' }

  for _, name in ipairs(candidates) do
    local runner = M[name]
    if runner and runner.detect() then
      return runner, name
    end
  end

  return nil, nil
end

return M
