return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>nn',
        function()
          require('secvim.sec_plugins.sectest').open()
        end,
        desc = 'Sectest: Menu',
      },
      {
        '<leader>nr',
        function()
          require('secvim.sec_plugins.sectest').run_nearest()
        end,
        desc = 'Sectest: Run Nearest',
      },
      {
        '<leader>nf',
        function()
          require('secvim.sec_plugins.sectest').run_file()
        end,
        desc = 'Sectest: Run File',
      },
      {
        '<leader>na',
        function()
          require('secvim.sec_plugins.sectest').run_all()
        end,
        desc = 'Sectest: Run All',
      },
      {
        '<leader>nl',
        function()
          require('secvim.sec_plugins.sectest').run_last()
        end,
        desc = 'Sectest: Run Last',
      },
      {
        '<leader>ns',
        function()
          require('secvim.sec_plugins.sectest').stop()
        end,
        desc = 'Sectest: Stop',
      },
      {
        '<leader>no',
        function()
          require('secvim.sec_plugins.sectest').toggle_output()
        end,
        desc = 'Sectest: Toggle Output',
      },
      {
        '<leader>np',
        function()
          require('secvim.sec_plugins.sectest').pick_test_files()
        end,
        desc = 'Sectest: Pick Test File',
      },
    },
  },
}
