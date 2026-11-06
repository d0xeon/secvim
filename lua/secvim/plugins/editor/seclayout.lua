return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/seclayout',
  name = 'seclayout',
  lazy = true,
  cmd = { 'SecLayout', 'SecLayoutClose' },
  keys = {
    {
      '<C-g>',
      function()
        require('secvim.sec_plugins.seclayout').toggle()
      end,
      desc = 'SecLayout: Toggle 4-pane grid',
    },
    {
      '<leader>lw',
      function()
        require('secvim.sec_plugins.seclayout').toggle()
      end,
      desc = 'SecLayout: Toggle 4-pane grid',
    },
  },
  config = function()
    vim.api.nvim_create_user_command('SecLayout', function()
      require('secvim.sec_plugins.seclayout').toggle()
    end, { desc = 'Toggle the 4-pane development layout' })

    vim.api.nvim_create_user_command('SecLayoutClose', function()
      require('secvim.sec_plugins.seclayout').close()
    end, { desc = 'Close the 4-pane development layout' })
  end,
}
