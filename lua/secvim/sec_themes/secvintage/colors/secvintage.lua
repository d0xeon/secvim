-- Clear module caches to ensure fresh evaluation
package.loaded['secvintage'] = nil
package.loaded['secvintage.colors'] = nil
package.loaded['secvintage.config'] = nil

local ok, appearance = pcall(require, 'secvim.config.appearance')
if ok then
  local overrides = require 'secvim.plugins.ui.colorschemes.secvintage.overrides'
  local mode = appearance.get_mode()
  local transparent = appearance.get_transparent()
  local secvintage = require 'secvintage'
  secvintage.setup {
    transparent = transparent,
    overrides = overrides.get(mode, transparent),
  }
  secvintage.colorscheme()
else
  require('secvintage').colorscheme()
end
