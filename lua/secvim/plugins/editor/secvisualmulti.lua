return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secvisualmulti',
  name = 'secvisualmulti',
  lazy = true,
  config = function()
    require('secvim.sec_plugins.secvisualmulti').setup()
  end,
  keys = {
    {
      '<C-n>',
      function()
        require('secvim.sec_plugins.secvisualmulti').find_under()
      end,
      desc = 'Secvisualmulti: Select Word / Next',
    },
    {
      '<C-Down>',
      function()
        require('secvim.sec_plugins.secvisualmulti').add_down()
      end,
      desc = 'Secvisualmulti: Cursor Down',
    },
    {
      '<C-Up>',
      function()
        require('secvim.sec_plugins.secvisualmulti').add_up()
      end,
      desc = 'Secvisualmulti: Cursor Up',
    },
    {
      '<C-n>',
      function()
        require('secvim.sec_plugins.secvisualmulti').from_visual()
      end,
      mode = 'x',
      desc = 'Secvisualmulti: Cursors From Selection',
    },
    {
      '<leader>kvv',
      function()
        require('secvim.sec_plugins.secvisualmulti').menu()
      end,
      desc = 'Secvisualmulti: Menu',
    },
    {
      '<leader>kva',
      function()
        require('secvim.sec_plugins.secvisualmulti').select_all()
      end,
      desc = 'Secvisualmulti: Select All Occurrences',
    },
    {
      '<leader>kvr',
      function()
        require('secvim.sec_plugins.secvisualmulti').rename()
      end,
      desc = 'Secvisualmulti: Rename Selection',
    },
  },
}
