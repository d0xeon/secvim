local toggles = require 'secvim.config.toggles'

return function()
  Snacks.toggle({
    name = 'Secterm Title',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secterm_title'
    end,
    set = function(state)
      toggles.set('secterm_title', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.refresh_chips()
      end
    end,
  }):map '<leader>lqrt'

  Snacks.toggle({
    name = 'Secterm Time',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secterm_time'
    end,
    set = function(state)
      toggles.set('secterm_time', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.refresh_chips()
      end
    end,
  }):map '<leader>lqrh'

  Snacks.toggle({
    name = 'Secterm Auto Insert',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'secterm_autoinsert'
    end,
    set = function(state)
      toggles.set('secterm_autoinsert', state)
    end,
  }):map '<leader>lari'

  -- Insert mode when directional focus lands on a terminal, vs staying in normal
  Snacks.toggle({
    name = 'Secterm Focus Insert',
    wk_desc = { enabled = 'Disable ', disabled = 'Enable ' },
    get = function()
      return toggles.get 'secterm_focus_insert'
    end,
    set = function(state)
      toggles.set('secterm_focus_insert', state)
    end,
  }):map '<leader>larf'

  -- Display name: ON = "Secterm", OFF = "Terminal"
  Snacks.toggle({
    name = 'Secterm Full Name',
    wk_desc = { enabled = 'Use ', disabled = 'Use ' },
    get = function()
      return toggles.get 'secterm_name_full'
    end,
    set = function(state)
      toggles.set('secterm_name_full', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.refresh_chips()
      end
    end,
  }):map '<leader>lqrn'

  -- Chip icon visibility (show/hide)
  Snacks.toggle({
    name = 'Secterm Icon',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secterm_icon_visible'
    end,
    set = function(state)
      toggles.set('secterm_icon_visible', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.refresh_chips()
      end
    end,
  }):map '<leader>lqrc'

  -- Chip icon style picker: 'sec' (󰧱) vs 'terminal' ()
  vim.keymap.set('n', '<leader>lqrC', function()
    local styles = {
      { name = 'sec', glyph = '󰧱', label = 'Sec' },
      { name = 'terminal', glyph = '', label = 'Terminal' }, -- nf-md-console U+F018D
    }
    local current = toggles.get 'secterm_icon_style'
    vim.ui.select(styles, {
      prompt = 'Secterm · select icon',
      kind = 'secterm_icon',
      format_item = function(s)
        local marker = s.name == current and ' ●' or ''
        return s.glyph .. '  ' .. s.label .. marker
      end,
    }, function(choice)
      if not choice then
        return
      end
      toggles.set('secterm_icon_style', choice.name)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.refresh_chips()
      end
      Snacks.notify.info('Secterm icon: ' .. choice.label)
    end)
  end, { desc = 'Secterm: Select Icon' })

  -- Vertical border (vsplit). When on, the vertical split becomes a pinned
  -- float with a rounded border. When off, it's a native split (no border).
  Snacks.toggle({
    name = 'Secterm Vertical Border',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secterm_vertical_border'
    end,
    set = function(state)
      toggles.set('secterm_vertical_border', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.reload_splits 'vertical'
      end
    end,
  }):map '<leader>lqrb'

  -- Horizontal border (split). Same mechanism — float-pinned when on.
  Snacks.toggle({
    name = 'Secterm Horizontal Border',
    wk_desc = { enabled = 'Hide ', disabled = 'Show ' },
    get = function()
      return toggles.get 'secterm_horizontal_border'
    end,
    set = function(state)
      toggles.set('secterm_horizontal_border', state)
      local ok, secterm = pcall(require, 'secvim.sec_plugins.secterm')
      if ok then
        secterm.reload_splits 'horizontal'
      end
    end,
  }):map '<leader>lqrB'

  -- Size picker (popup): compact / default / wide
  vim.keymap.set('n', '<leader>lqrz', function()
    require('secvim.sec_plugins.secterm').pick_size()
  end, { desc = 'Secterm: Select Size' })

  -- Theme selector — uses vim.ui.select so it follows the snacks picker style
  vim.keymap.set('n', '<leader>lqrs', function()
    local themes = require 'secvim.sec_plugins.secterm.themes'
    local current = themes.current().name
    vim.ui.select(themes.list, {
      prompt = 'Secterm · select theme',
      kind = 'secterm_theme',
      format_item = function(t)
        local marker = t.name == current and ' ●' or ''
        return t.icon .. ' ' .. t.label .. marker
      end,
    }, function(choice)
      if not choice then
        return
      end
      themes.set(choice.name)
      Snacks.notify.info('Secterm theme: ' .. choice.label)
    end)
  end, { desc = 'Secterm: Select Theme' })
end
