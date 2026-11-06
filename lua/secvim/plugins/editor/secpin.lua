return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>oo',
        function()
          require('secvim.sec_plugins.secpin').toggle()
        end,
        desc = 'Secpin: Pin',
      },
      {
        '<leader>oe',
        function()
          require('secvim.sec_plugins.secpin').toggle_tags()
        end,
        desc = 'Secpin: Menu',
      },
      {
        '<leader>o1',
        function()
          require('secvim.sec_plugins.secpin').select(1)
        end,
        desc = 'Secpin: Jump 1',
      },
      {
        '<leader>o2',
        function()
          require('secvim.sec_plugins.secpin').select(2)
        end,
        desc = 'Secpin: Jump 2',
      },
      {
        '<leader>o3',
        function()
          require('secvim.sec_plugins.secpin').select(3)
        end,
        desc = 'Secpin: Jump 3',
      },
      {
        '<leader>o4',
        function()
          require('secvim.sec_plugins.secpin').select(4)
        end,
        desc = 'Secpin: Jump 4',
      },
      {
        '<leader>o5',
        function()
          require('secvim.sec_plugins.secpin').select(5)
        end,
        desc = 'Secpin: Jump 5',
      },
      {
        '<leader>o6',
        function()
          require('secvim.sec_plugins.secpin').select(6)
        end,
        desc = 'Secpin: Jump 6',
      },
      {
        '<leader>o7',
        function()
          require('secvim.sec_plugins.secpin').select(7)
        end,
        desc = 'Secpin: Jump 7',
      },
      {
        '<leader>o8',
        function()
          require('secvim.sec_plugins.secpin').select(8)
        end,
        desc = 'Secpin: Jump 8',
      },
      {
        '<leader>o9',
        function()
          require('secvim.sec_plugins.secpin').select(9)
        end,
        desc = 'Secpin: Jump 9',
      },
      {
        '<leader>o0',
        function()
          require('secvim.sec_plugins.secpin').select(10)
        end,
        desc = 'Secpin: Jump 10',
      },
      {
        '<leader>of',
        function()
          require('secvim.sec_plugins.secpin').picker()
        end,
        desc = 'Secpin: Search',
      },
      {
        '<leader>oj',
        function()
          require('secvim.sec_plugins.secpin').cycle 'prev'
        end,
        desc = 'Secpin: Prev',
      },
      {
        '<leader>ok',
        function()
          require('secvim.sec_plugins.secpin').cycle 'next'
        end,
        desc = 'Secpin: Next',
      },
    },
  },
}
