return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secpick',
  name = 'secpick',
  lazy = true,
  keys = {
    {
      '<leader>m',
      function()
        require('secvim.sec_plugins.secpick').pick()
      end,
      desc = 'Secpick',
    },
    {
      '<leader>S',
      function()
        require('secvim.sec_plugins.secpick').pick()
      end,
      desc = 'Secpick',
    },
    {
      '<leader>cd',
      function()
        require('secvim.sec_plugins.secpick').close()
      end,
      desc = 'Close Window (Pick)',
    },
  },
}
