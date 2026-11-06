local M = {}

function M.check()
  local secvim = require 'secvim'

  vim.health.start(secvim.name .. ' v' .. secvim.version)

  -- Neovim version: the config uses lsp/*.lua runtime configs, vim.fs.root,
  -- winborder and vim.lsp.enable, all 0.11+/0.12 APIs.
  local nvim = vim.version()
  if vim.fn.has 'nvim-0.12' == 1 then
    vim.health.ok('Neovim v' .. nvim.major .. '.' .. nvim.minor .. '.' .. nvim.patch)
  else
    vim.health.error('Neovim >= 0.12 required', 'Update Neovim')
  end

  -- Git
  if vim.fn.executable 'git' == 1 then
    vim.health.ok 'git found'
  else
    vim.health.error 'git not found'
  end

  -- Node
  if vim.fn.executable 'node' == 1 then
    vim.health.ok 'node found'
  else
    vim.health.warn 'node not found (needed for some LSPs and plugins)'
  end

  -- Ripgrep
  if vim.fn.executable 'rg' == 1 then
    vim.health.ok 'ripgrep found'
  else
    vim.health.warn 'ripgrep not found (needed for telescope/snacks live grep)'
  end

  -- fd
  if vim.fn.executable 'fd' == 1 then
    vim.health.ok 'fd found'
  else
    vim.health.warn 'fd not found (needed for file pickers)'
  end

  -- Optional tools the distro integrates with
  for tool, hint in pairs {
    lazygit = 'needed for the git UI (snacks lazygit)',
    yazi = 'needed for the yazi file manager',
    chafa = 'needed for the dashboard GIF toggle',
    tmux = 'needed for Neovim <-> tmux pane navigation',
  } do
    if vim.fn.executable(tool) == 1 then
      vim.health.ok(tool .. ' found')
    else
      vim.health.warn(tool .. ' not found (' .. hint .. ')')
    end
  end

  -- Security stacks
  local solidity_ls = vim.fn.executable 'nomicfoundation-solidity-language-server' == 1 and 'nomicfoundation-solidity-language-server'
    or (vim.fn.executable 'vscode-solidity-server' == 1 and 'vscode-solidity-server' or nil)
  if solidity_ls then
    vim.health.ok('Solidity LSP found (' .. solidity_ls .. ')')
  else
    vim.health.warn('Solidity LSP not found', 'Mason: nomicfoundation-solidity-language-server')
  end

  for tool, hint in pairs {
    gopls = 'Go LSP',
    dlv = 'Go debug adapter (Delve)',
    ['rust-analyzer'] = 'Rust LSP',
    ruff = 'Python LSP/formatter',
    ['js-debug-adapter'] = 'JavaScript/TypeScript debug adapter',
    clangd = 'C/C++ LSP',
    clang = 'C/C++ compiler',
    ['clang-format'] = 'C/C++ formatter',
    cmake = 'CMake build + compile_commands.json',
    ctest = 'CTest runner',
    codelldb = 'Rust/C/C++ debug adapter',
    forge = 'Foundry (Solidity tests + forge fmt)',
    solc = 'Solidity compiler',
    solhint = 'Solidity linter',
    shellcheck = 'Shell linter',
  } do
    if vim.fn.executable(tool) == 1 then
      vim.health.ok(tool .. ' found')
    else
      vim.health.warn(tool .. ' not found (' .. hint .. ')')
    end
  end

  -- Persisted state files: appearance.setup() and toggles._load() read these
  -- silently, so surface breakage here instead
  local cache = vim.fn.stdpath 'cache'
  for _, name in ipairs { 'secvim-background', 'secvim-colorscheme', 'secvim-transparent', 'secvim-toggles' } do
    local path = cache .. '/' .. name
    local stat = vim.uv.fs_stat(path)
    if not stat then
      vim.health.info(name .. ' not created yet (defaults in use)')
    elseif vim.fn.filereadable(path) == 1 and vim.fn.filewritable(path) == 1 then
      vim.health.ok(name .. ' readable and writable')
    else
      vim.health.error(name .. ' exists but is not readable/writable', 'Check permissions on ' .. path)
    end
  end

  -- Lazy
  local lazy_ok, lazy = pcall(require, 'lazy')
  if lazy_ok then
    local stats = lazy.stats()
    vim.health.ok(stats.loaded .. '/' .. stats.count .. ' plugins loaded in ' .. string.format('%.2fms', stats.startuptime))
  else
    vim.health.error 'lazy.nvim not found'
  end
end

return M
