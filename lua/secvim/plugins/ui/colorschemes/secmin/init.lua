local appearance = require 'secvim.config.appearance'

-- Only the active (cached) theme loads at startup; the other themes are
-- lazy and load through lazy.nvim's colorscheme handler on switch.
local active = (appearance.get_colorscheme() or 'secwave') == 'secmin'

local function setup_theme()
  local overrides = require 'secvim.plugins.ui.colorschemes.secmin.overrides'
  local mode = appearance.get_mode()
  local transparent_background = appearance.get_transparent()
  require('secmin').setup {
    transparent = transparent_background,
    bold = true,
    strikethrough = true,
    italics = {
      comments = true,
      keywords = true,
      functions = true,
      strings = true,
      variables = true,
    },
    overrides = overrides.get(mode, transparent_background),
  }
end

return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_themes/secmin',
    name = 'secmin',
    lazy = not active,
    priority = 1000,
    config = function()
      setup_theme()
      appearance.register_reloader('secmin', function()
        setup_theme()
        vim.cmd 'colorscheme secmin'
      end)
    end,
  },
}
