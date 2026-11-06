return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/sectools',
  name = 'sectools',
  lazy = true,
  keys = {
    {
      '<leader>kt',
      function()
        require('secvim.sec_plugins.sectools').menu 'normal'
      end,
      mode = 'n',
      desc = 'Sectools: Transform Text',
    },
    {
      '<leader>kt',
      function()
        require('secvim.sec_plugins.sectools').menu 'visual'
      end,
      mode = 'x',
      desc = 'Sectools: Transform Selection',
    },
    {
      '<leader>kx',
      function()
        require('secvim.sec_plugins.sectools').hexdump()
      end,
      desc = 'Sectools: Hex Dump File',
    },
  },
}
