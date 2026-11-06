return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>kk',
        function()
          require('secvim.sec_plugins.seckit').open()
        end,
        desc = 'SecKit: Menu',
      },
      {
        '<leader>ka',
        function()
          require('secvim.sec_plugins.seckit').lsp_actions()
        end,
        desc = 'SecKit: LSP Actions',
      },
    },
  },
}
