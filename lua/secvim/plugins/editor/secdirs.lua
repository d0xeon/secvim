return {
  {
    'folke/snacks.nvim',
    keys = {
      {
        '<leader>lp',
        function()
          require('secvim.sec_plugins.secdirs').open()
        end,
        desc = 'Secdirs: Manage Projects & Obsidian',
      },
    },
  },
}
