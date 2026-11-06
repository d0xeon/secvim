local toggles = require 'secvim.config.toggles'

local lsp_group = vim.api.nvim_create_augroup('UserLspConfig', { clear = true })

-- Document highlight is handled by snacks.words (one request stream, plus
-- ]]/[[ reference navigation); no manual CursorHold pipeline here.
vim.api.nvim_create_autocmd('LspAttach', {
  group = lsp_group,
  callback = function(event)
    local map = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>r', vim.lsp.buf.rename, 'Rename')
    map('<leader>la', vim.lsp.buf.code_action, 'Code Action')

    local inlay_filetypes = {
      rust = true,
      go = true,
      c = true,
      cpp = true,
      objc = true,
      objcpp = true,
      cuda = true,
      javascript = true,
      javascriptreact = true,
      typescript = true,
      typescriptreact = true,
    }
    if inlay_filetypes[vim.bo[event.buf].filetype] and vim.lsp.inlay_hint then
      pcall(vim.lsp.inlay_hint.enable, true, { bufnr = event.buf })
    end

    map('<leader>lh', function()
      local enabled = vim.lsp.inlay_hint.is_enabled { bufnr = event.buf }
      vim.lsp.inlay_hint.enable(not enabled, { bufnr = event.buf })
    end, 'Toggle Inlay Hints')

    local cpp_filetypes = { c = true, cpp = true, objc = true, objcpp = true, cuda = true }
    if cpp_filetypes[vim.bo[event.buf].filetype] then
      local function switch_source_header()
        local client = vim.lsp.get_clients({ bufnr = event.buf, name = 'clangd' })[1]
        if not client then
          return
        end
        client:request('textDocument/switchSourceHeader', { uri = vim.uri_from_bufnr(event.buf) }, function(err, result)
          if err then
            vim.notify('Switch header/source: ' .. tostring(err), vim.log.levels.WARN)
            return
          end
          if not result or result == '' then
            vim.notify('Switch header/source: no matching file', vim.log.levels.WARN)
            return
          end
          vim.cmd('edit ' .. vim.fn.fnameescape(vim.uri_to_fname(result)))
        end, event.buf)
      end
      map('<F4>', switch_source_header, 'Switch Header/Source')
      map('<M-o>', switch_source_header, 'Switch Header/Source')
    end
  end,
})

-- superhtml exits with code 1 on malformed HTML; keep that noise out of the
-- notifier. Wrapped here (after snacks owns vim.notify) via lazy scheduling.
vim.schedule(function()
  local orig_notify = vim.notify
  vim.notify = function(msg, ...)
    if type(msg) == 'string' and msg:find('Client superhtml quit', 1, true) then
      return
    end
    return orig_notify(msg, ...)
  end
end)

local severity = vim.diagnostic.severity
vim.diagnostic.config {
  virtual_text = { current_line = toggles.get 'virtual_text_current_line' },
  signs = {
    text = {
      [severity.ERROR] = ' ',
      [severity.WARN] = ' ',
      [severity.HINT] = '󱠇 ',
      [severity.INFO] = ' ',
    },
  },
  underline = true,
  -- Neovim's default (false) on purpose: with this on, every keystroke in
  -- insert mode re-publishes diagnostics, which re-lays out all virtual text,
  -- re-renders the bufferline (diagnostics = 'nvim_lsp') and redraws the
  -- statusline. On a big TS file that is the single biggest source of typing
  -- lag. Diagnostics still refresh on InsertLeave and on every LSP publish.
  update_in_insert = false,
  severity_sort = true,
}
