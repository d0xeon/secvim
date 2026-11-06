-- Clear module caches to ensure fresh evaluation
package.loaded['secnight'] = nil
package.loaded['secnight.colors'] = nil
package.loaded['secnight.config'] = nil

local ok, appearance = pcall(require, 'secvim.config.appearance')
if ok then
  local overrides = require 'secvim.plugins.ui.colorschemes.secnight.overrides'
  local mode = appearance.get_mode()
  local transparent = appearance.get_transparent()
  local secnight = require 'secnight'
  secnight.setup {
    transparent = transparent,
    overrides = overrides.get(mode, transparent),
  }
  secnight.colorscheme()
else
  require('secnight').colorscheme()
end
