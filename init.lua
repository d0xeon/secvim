vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Silence the `client.supports_method` deprecation (comes from plugins, not this config)
do
  local original = vim.deprecate
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.deprecate = function(name, ...)
    if name == 'client.supports_method' then
      return
    end
    return original(name, ...)
  end
end

require 'secvim'
require 'secvim.config.keybinds'
require 'secvim.config.vscode'
require 'secvim.config.autocmds'
require 'secvim.config.options'
require 'secvim.config.filetypes'
require 'secvim.lsp.lsp-handlers'

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end
vim.opt.rtp:prepend(lazypath)

-- Some plugins call get_node_text on nodes from parsers this distro does not
-- ship (bundled-parsers-only policy) and would error; swallow that into an
-- empty string. Remove if the no-extra-parsers policy ever changes.
do
  local original = vim.treesitter.get_node_text
  ---@diagnostic disable-next-line: duplicate-set-field
  vim.treesitter.get_node_text = function(node, source, opts)
    local ok, result = pcall(original, node, source, opts)
    if ok then
      return result
    end
    return ''
  end
end

require('lazy').setup({

  { import = 'secvim.plugins.env.lsp' },
  { import = 'secvim.plugins.env' },
  { import = 'secvim.plugins.language' },
  { import = 'secvim.plugins.ui' },
  { import = 'secvim.plugins.ui.colorschemes' },
  { import = 'secvim.plugins.coding' },
  { import = 'secvim.plugins.editor' },
  { import = 'secvim.plugins.ai' },
  { import = 'secvim.plugins.test' },
}, {
  install = { colorscheme = { 'secwave', 'secmin', 'habamax' } },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
