-- Clear module caches to ensure fresh evaluation
package.loaded['secjet'] = nil
package.loaded['secjet.colors'] = nil
package.loaded['secjet.config'] = nil

local ok, appearance = pcall(require, 'secvim.config.appearance')
if ok then
  local overrides = require 'secvim.plugins.ui.colorschemes.secjet.overrides'
  local mode = appearance.get_mode()
  local transparent = appearance.get_transparent()
  local secjet = require 'secjet'
  secjet.setup {
    transparent = transparent,
    overrides = overrides.get(mode, transparent),
  }
  secjet.colorscheme()
else
  require('secjet').colorscheme()
end
