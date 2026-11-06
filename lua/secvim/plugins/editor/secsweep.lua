return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secsweep',
  name = 'secsweep',
  event = 'VeryLazy',
  config = function()
    require('secvim.sec_plugins.secsweep').setup()
  end,
}
