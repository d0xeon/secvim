return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secsave',
  name = 'secsave',
  -- Only pay for the module when autosave is actually on; the toggle
  -- requires the module directly, so flipping it later still works.
  event = require('secvim.config.toggles').get 'autosave' and { 'InsertLeave', 'TextChanged' } or nil,
  config = function()
    require('secvim.sec_plugins.secsave').setup()
  end,
  -- Toggle keymap defined in snacks/toggles.lua
}
