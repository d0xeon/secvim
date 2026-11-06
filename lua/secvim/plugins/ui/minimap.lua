return {
  {
    'wfxr/minimap.vim',
    lazy = false,
    config = function()
      vim.g.minimap_width = 10
      vim.g.minimap_highlight_range = 1
      -- Do not let minimap.vim open on every window (including the sidebar);
      -- open it only for real file buffers.
      vim.g.minimap_auto_start = 0
      vim.g.minimap_auto_start_win_enter = 0

      local function skip(buf)
        local ft = vim.bo[buf].filetype
        -- The SecLayout tab is a fixed 2x2 grid; a 10-column minimap would
        -- turn it into a fifth pane and squeeze both terminal columns. The
        -- building flag covers the moment before the layout tab exists.
        if vim.g.seclayout_building or vim.t[vim.api.nvim_get_current_tabpage()].seclayout then
          return true
        end
        return vim.bo[buf].buftype ~= '' or ft == 'neo-tree' or ft == 'help' or ft == 'TelescopePrompt' or ft:match '^snacks'
      end

      vim.api.nvim_create_autocmd('BufWinEnter', {
        callback = function(args)
          if skip(args.buf) or vim.api.nvim_buf_line_count(args.buf) < 2 then
            return
          end
          if vim.fn.bufwinnr '-MINIMAP-' ~= -1 then
            return
          end
          pcall(vim.cmd, 'Minimap')
        end,
      })
    end,
    keys = {
      { '<leader>M', '<cmd>MinimapToggle<cr>', desc = 'Toggle minimap' },
    },
  },
}
