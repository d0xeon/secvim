return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>lo',
        function()
          require('secvim.sec_plugins.secsnippets').open()
        end,
        desc = 'Secsnippets: Manage Snippets',
      },
    },
  },
}
