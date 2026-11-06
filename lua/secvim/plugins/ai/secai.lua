--- SecAI - Plugin spec wiring keymaps for the native AI CLI integration
return {
  dir = vim.fn.stdpath 'config' .. '/lua/secvim/sec_plugins/secai',
  name = 'secai',
  lazy = true,
  -- Register the review keybinds at startup based on the master `secai_review`
  -- toggle, so <leader>ar / <leader>ab exist (and show in which-key) when the
  -- feature is on and are absent when it is off. The RHS is lazy (requires the
  -- module only on press), so this does not defeat lazy-loading. Runtime flips
  -- go through secai.apply_review_keymaps() from the toggle's set().
  init = function()
    local ok, toggles = pcall(require, 'secvim.config.toggles')
    if ok and toggles.get 'secai_review' == false then
      return
    end
    vim.keymap.set('n', '<leader>ar', function()
      require('secvim.sec_plugins.secai').review()
    end, { desc = 'SecAI: Review AI Changes' })
    vim.keymap.set('n', '<leader>ab', function()
      require('secvim.sec_plugins.secai').mark_baseline()
    end, { desc = 'SecAI: Mark Review Baseline' })
  end,
  keys = {
    { '<leader>a', '', desc = '+ai', mode = { 'n', 'v' } },
    {
      '<c-.>',
      function()
        require('secvim.sec_plugins.secai').focus()
      end,
      desc = 'SecAI: Focus',
      mode = { 'n', 't', 'i', 'x' },
    },

    -- Smart toggle: picker on the very first open, then reuses the last layout
    {
      '<leader>aa',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker()
      end,
      desc = 'SecAI: Toggle CLI',
    },
    {
      '<leader>aa',
      function()
        require('secvim.sec_plugins.secai').ask_with_preview()
      end,
      mode = 'x',
      desc = 'SecAI: Ask (preview + prompt)',
    },

    -- Direct layout switchers
    {
      '<leader>av',
      function()
        require('secvim.sec_plugins.secai').open_in_layout 'right'
      end,
      desc = 'SecAI: Open Vertical',
    },
    {
      '<leader>ah',
      function()
        require('secvim.sec_plugins.secai').open_in_layout 'bottom'
      end,
      desc = 'SecAI: Open Horizontal',
    },
    {
      '<leader>af',
      function()
        require('secvim.sec_plugins.secai').open_in_layout 'float'
      end,
      desc = 'SecAI: Open Float',
    },

    -- Selection / prompts / sends
    {
      '<leader>as',
      function()
        require('secvim.sec_plugins.secai').select()
      end,
      desc = 'SecAI: Select CLI + Layout',
    },
    {
      '<leader>ad',
      function()
        require('secvim.sec_plugins.secai').close_pick()
      end,
      desc = 'SecAI: Close a CLI',
    },
    {
      '<leader>aD',
      function()
        require('secvim.sec_plugins.secai').close_all()
      end,
      desc = 'SecAI: Close all CLIs',
    },
    {
      '<leader>am',
      function()
        require('secvim.sec_plugins.secai').minimize_pick()
      end,
      desc = 'SecAI: Minimize (pick)',
    },
    {
      '<leader>at',
      function()
        require('secvim.sec_plugins.secai').send_ref { msg = '{this}' }
      end,
      mode = { 'x', 'n' },
      desc = 'SecAI: Send This',
    },
    {
      '<leader>al',
      function()
        require('secvim.sec_plugins.secai').send_ref { msg = '{file}' }
      end,
      desc = 'SecAI: Send File',
    },
    {
      '<leader>av',
      function()
        require('secvim.sec_plugins.secai').send { msg = '{selection}' }
      end,
      mode = { 'x' },
      desc = 'SecAI: Send Visual Selection',
    },
    {
      '<leader>ap',
      function()
        require('secvim.sec_plugins.secai').prompt()
      end,
      mode = { 'n', 'x' },
      desc = 'SecAI: Select Prompt',
    },

    -- Review keybinds (<leader>ar / <leader>ab) are registered dynamically by
    -- secai.apply_review_keymaps() so the master `secai_review` toggle can
    -- hide them from which-key when the feature is off.

    -- Per-tool toggles
    {
      '<leader>ac',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker 'claude'
      end,
      desc = 'SecAI: Toggle Claude Code',
    },
    {
      '<leader>au',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker 'cursor'
      end,
      desc = 'SecAI: Toggle Cursor',
    },
    {
      '<leader>ao',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker 'openclaude'
      end,
      desc = 'SecAI: Toggle OpenClaude',
    },
    {
      -- 'o' is OpenClaude and 'c'/'p' are taken, so OpenCode gets 'e'.
      '<leader>ae',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker 'opencode'
      end,
      desc = 'SecAI: Toggle OpenCode',
    },
    {
      '<leader>ag',
      function()
        require('secvim.sec_plugins.secai').toggle_with_picker 'gemini'
      end,
      desc = 'SecAI: Toggle Gemini',
    },
  },
}
