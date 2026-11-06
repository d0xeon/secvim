local appearance = require 'secvim.config.appearance'

-- Only the active (cached) theme loads at startup; the other themes are
-- lazy and load through lazy.nvim's colorscheme handler on switch.
local active = (appearance.get_colorscheme() or 'secwave') == 'secjet'

local function setup_theme()
  local overrides = require 'secvim.plugins.ui.colorschemes.secjet.overrides'
  local mode = appearance.get_mode()
  local transparent_background = appearance.get_transparent()
  require('secjet').setup {
    transparent = transparent_background,
    overrides = overrides.get(mode, transparent_background),
  }
end

return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_themes/secjet',
  name = 'secjet',
  lazy = not active,
  priority = 1000,
  config = function()
    setup_theme()
    appearance.register_reloader('secjet', function()
      setup_theme()
      vim.cmd 'colorscheme secjet'
    end)
  end,
}
