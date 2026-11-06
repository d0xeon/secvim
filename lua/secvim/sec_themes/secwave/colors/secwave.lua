-- Clear module caches to ensure fresh evaluation
package.loaded['secwave'] = nil
package.loaded['secwave.colors'] = nil

local ok, appearance = pcall(require, 'secvim.config.appearance')
local transparent = ok and appearance.get_transparent() or false
local mode = (vim.o.background == 'light' and not transparent) and 'light' or 'dark'
-- kanagawa-dragon (dark) / kanagawa-lotus (light) — the only two variants
-- this port ships.
local theme = mode == 'light' and 'lotus' or 'dragon'

local overrides_ok, overrides = pcall(require, 'secvim.plugins.ui.colorschemes.secwave.overrides')
local override_table = (overrides_ok and overrides.get(mode, transparent)) or {}

local secwave = require 'secwave'
secwave.setup {
  transparent = transparent,
  overrides = function()
    return override_table
  end,
}
secwave.load(theme)
