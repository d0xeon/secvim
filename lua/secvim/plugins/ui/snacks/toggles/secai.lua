local toggles = require 'secvim.config.toggles'

return function()
  -- Title chip (show/hide)
  Snacks.toggle({
    name = 'SecAI Title',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secai_title'
    end,
    set = function(state)
      toggles.set('secai_title', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.refresh_chips()
      end
    end,
  }):map '<leader>lqat'

  -- Time inside chip
  Snacks.toggle({
    name = 'SecAI Time',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secai_time'
    end,
    set = function(state)
      toggles.set('secai_time', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.refresh_chips()
      end
    end,
  }):map '<leader>lqah'

  -- Auto insert when opening a CLI
  Snacks.toggle({
    name = 'SecAI Auto Insert',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'secai_autoinsert'
    end,
    set = function(state)
      toggles.set('secai_autoinsert', state)
    end,
  }):map '<leader>laai'

  -- Auto focus when sending a message
  Snacks.toggle({
    name = 'SecAI Auto Focus',
    get = function()
      return toggles.get 'secai_auto_focus'
    end,
    set = function(state)
      toggles.set('secai_auto_focus', state)
    end,
  }):map '<leader>laaf'

  -- Master switch for the whole Review feature (keybinds, badge, auto-open).
  -- When off, the review keybinds are removed (hidden from which-key) and no
  -- baseline is captured.
  Snacks.toggle({
    name = 'SecAI Review',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'secai_review'
    end,
    set = function(state)
      toggles.set('secai_review', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.apply_review_keymaps()
      end
      local rok, review = pcall(require, 'secvim.sec_plugins.secai.review')
      if rok then
        if not state and review.is_open() then
          review.close()
        end
        review.refresh_pending()
      end
      if ok and secai.refresh_chips then
        secai.refresh_chips()
      end
    end,
  }):map '<leader>aR'

  -- Auto-open the review panel after the AI edits files
  Snacks.toggle({
    name = 'SecAI Auto Review',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'secai_auto_review'
    end,
    set = function(state)
      toggles.set('secai_auto_review', state)
    end,
  }):map '<leader>aA'

  -- Show the pending-review count badge on the CLI chip
  Snacks.toggle({
    name = 'SecAI Review Badge',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secai_review_badge'
    end,
    set = function(state)
      toggles.set('secai_review_badge', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.refresh_chips()
      end
    end,
  }):map '<leader>lqac'

  -- Theme picker (popup)
  vim.keymap.set('n', '<leader>lqas', function()
    require('secvim.sec_plugins.secai.ui').pick_theme()
  end, { desc = 'SecAI: Select Theme' })

  -- Position picker (popup)
  vim.keymap.set('n', '<leader>lqap', function()
    require('secvim.sec_plugins.secai.ui').pick_position()
  end, { desc = 'SecAI: Select Position' })

  -- Size picker (popup)
  vim.keymap.set('n', '<leader>lqaz', function()
    require('secvim.sec_plugins.secai.ui').pick_size()
  end, { desc = 'SecAI: Select Size' })

  -- Vertical border (right/left/float)
  Snacks.toggle({
    name = 'SecAI Vertical Border',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secai_vertical_border'
    end,
    set = function(state)
      toggles.set('secai_vertical_border', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.relayout()
      end
    end,
  }):map '<leader>lqab'

  -- Horizontal border (bottom)
  Snacks.toggle({
    name = 'SecAI Horizontal Border',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secai_horizontal_border'
    end,
    set = function(state)
      toggles.set('secai_horizontal_border', state)
      local ok, secai = pcall(require, 'secvim.sec_plugins.secai')
      if ok then
        secai.relayout()
      end
    end,
  }):map '<leader>lqaB'
end
