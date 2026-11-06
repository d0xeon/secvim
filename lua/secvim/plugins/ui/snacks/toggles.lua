local toggles = require 'secvim.config.toggles'

local function persist_toggle(snacks_toggle, key)
  local orig_toggle = snacks_toggle.toggle
  snacks_toggle.toggle = function(self)
    orig_toggle(self)
    toggles.set(key, self:get())
  end
  return snacks_toggle
end

-- Load toggle modules
require 'secvim.plugins.ui.snacks.toggles.options'(persist_toggle)
require 'secvim.plugins.ui.snacks.toggles.plugins'()
require 'secvim.plugins.ui.snacks.toggles.appearance'()
require 'secvim.plugins.ui.snacks.toggles.autocmds'()
require 'secvim.plugins.ui.snacks.toggles.dashboard_gif'()
require 'secvim.plugins.ui.snacks.toggles.secterm'()
require 'secvim.plugins.ui.snacks.toggles.secai'()
require 'secvim.plugins.ui.snacks.toggles.force_bg'()
require 'secvim.plugins.ui.snacks.toggles.dropbar'()
require 'secvim.plugins.ui.snacks.toggles.todo'()
require 'secvim.plugins.ui.snacks.toggles.secmaximize'()
require 'secvim.plugins.ui.snacks.toggles.sectag'()

-- Restore persisted states
if toggles.get 'indent' then
  Snacks.toggle.indent():set(true)
end
if toggles.get 'dim' then
  Snacks.toggle.dim():set(true)
end
if not toggles.get 'render_markdown' then
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    once = true,
    callback = function()
      vim.schedule(function()
        vim.cmd 'RenderMarkdown disable'
      end)
    end,
  })
end
