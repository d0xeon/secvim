local appearance = require 'secvim.config.appearance'

-- Only the active (cached) theme loads at startup; the other themes are
-- lazy and load through lazy.nvim's colorscheme handler on switch.
local active = (appearance.get_colorscheme() or 'secwave') == 'secvintage'

local function setup_theme()
  local overrides = require 'secvim.plugins.ui.colorschemes.secvintage.overrides'
  local mode = appearance.get_mode()
  local transparent_background = appearance.get_transparent()
  require('secvintage').setup {
    transparent = transparent_background,
    overrides = overrides.get(mode, transparent_background),
  }
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_themes/secvintage',
  name = 'secvintage',
  lazy = not active,
  priority = 1000,
  config = function()
    setup_theme()
    appearance.register_reloader('secvintage', function()
      setup_theme()
      vim.cmd 'colorscheme secvintage'
    end)
  end,
}
