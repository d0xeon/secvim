return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>xx',
        function()
          require('secvim.sec_plugins.secfile').open()
        end,
        desc = 'Secfile: Menu',
      },
      {
        '<leader>xa',
        function()
          require('secvim.sec_plugins.secfile').create_here()
        end,
        desc = 'Secfile: Create here',
      },
      {
        '<leader>xr',
        function()
          require('secvim.sec_plugins.secfile').create_root()
        end,
        desc = 'Secfile: Create from root',
      },
      {
        '<leader>xn',
        function()
          require('secvim.sec_plugins.secfile').rename()
        end,
        desc = 'Secfile: Rename',
      },
      {
        '<leader>xc',
        function()
          require('secvim.sec_plugins.secfile').copy()
        end,
        desc = 'Secfile: Duplicate',
      },
      {
        '<leader>xi',
        function()
          require('secvim.sec_plugins.secfile').info()
        end,
        desc = 'Secfile: Info',
      },
      {
        '<leader>xd',
        function()
          require('secvim.sec_plugins.secfile').delete()
        end,
        desc = 'Secfile: Delete',
      },
    },
  },
}
