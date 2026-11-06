return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secbuild',
  name = 'secbuild',
  lazy = true,
  keys = {
    {
      '<F7>',
      function()
        require('secvim.sec_plugins.secbuild').build()
      end,
      desc = 'SecBuild: Build Project',
    },
    {
      '<C-S-b>',
      function()
        require('secvim.sec_plugins.secbuild').build()
      end,
      desc = 'SecBuild: Build Project',
    },
    {
      '<F6>',
      function()
        require('secvim.sec_plugins.secbuild').run_menu()
      end,
      desc = 'SecBuild: Compile & Run C/C++',
    },
    {
      '<leader>kb',
      function()
        require('secvim.sec_plugins.secbuild').menu()
      end,
      desc = 'SecBuild: Menu',
    },
  },
}
