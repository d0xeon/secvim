-- Clear module caches to ensure fresh evaluation
package.loaded['secmin'] = nil
package.loaded['secmin.colors'] = nil
package.loaded['secmin.config'] = nil

local ok, appearance = pcall(require, 'secvim.config.appearance')
if ok then
  local overrides = require 'secvim.plugins.ui.colorschemes.secmin.overrides'
  local mode = appearance.get_mode()
  local transparent = appearance.get_transparent()
  local effective_mode = transparent and 'dark' or mode
  local secmin = require 'secmin'
  secmin.setup {
    transparent = transparent,
    bold = true,
    strikethrough = true,
    italics = {
      comments = true,
      keywords = true,
      functions = true,
      strings = true,
      variables = true,
    },
    overrides = overrides.get(effective_mode, transparent),
  }
  secmin.colorscheme()
else
  require('secmin').colorscheme()
end
