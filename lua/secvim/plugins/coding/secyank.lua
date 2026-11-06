return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secyank',
  name = 'secyank',
  event = { 'TextYankPost' },
  config = function()
    require('secvim.sec_plugins.secyank').setup()
  end,
  keys = {
    {
      '<leader>p',
      function()
        require('secvim.sec_plugins.secyank').pick()
      end,
      mode = { 'n', 'x' },
      desc = 'Secyank: History',
    },
    {
      '<leader>P',
      function()
        require('secvim.sec_plugins.secyank').menu()
      end,
      desc = 'Secyank: Menu',
    },
  },
}
