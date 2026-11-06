local appearance = require 'secvim.config.appearance'

-- Only the active (cached) theme loads at startup; the other themes are
-- lazy and load through lazy.nvim's colorscheme handler on switch.
local active = (appearance.get_colorscheme() or 'secwave') == 'secwave'

-- kanagawa-dragon is the dark variant, kanagawa-lotus the light one — the
-- only two of kanagawa's three palettes this port ships.
local function setup_theme()
  local overrides = require 'secvim.plugins.ui.colorschemes.secwave.overrides'
  local mode = appearance.get_mode()
  local transparent_background = appearance.get_transparent()
  local effective_mode = transparent_background and 'dark' or mode
  local theme = effective_mode == 'light' and 'lotus' or 'dragon'
  local secwave = require 'secwave'
  secwave.setup {
    transparent = transparent_background,
    overrides = function()
      return overrides.get(effective_mode, transparent_background)
    end,
  }
  secwave.load(theme)
end

return {
  {
    dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_themes/secwave',
    name = 'secwave',
    lazy = not active,
    priority = 1000,
    config = function()
      setup_theme()
      appearance.register_reloader('secwave', function()
        setup_theme()
        vim.cmd 'colorscheme secwave'
      end)
    end,
  },
}
