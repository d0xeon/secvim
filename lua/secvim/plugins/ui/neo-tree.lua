return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      { '<leader>E', '<cmd>Neotree toggle<cr>', desc = 'Toggle project sidebar' },
      { '<leader>ER', '<cmd>Neotree reveal<cr>', desc = 'Reveal current file in sidebar' },
    },
    opts = {
      close_if_last_window = true,
      popup_border_style = 'rounded',
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        hijack_netrw_behavior = 'open_default',
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
      },
      window = {
        position = 'left',
        width = 32,
      },
    },
    config = function(_, opts)
      require('neo-tree').setup(opts)

      -- Keep a VS Code-style project panel visible from the first screen.
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          vim.schedule(function()
            pcall(vim.cmd, 'Neotree show')
          end)
        end,
      })
    end,
  },
}
