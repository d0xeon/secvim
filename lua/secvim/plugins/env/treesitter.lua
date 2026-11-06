vim.filetype.add {
  pattern = {
    ['.*%.blade%.php'] = 'blade',
    ['.*%.html%.jinja'] = 'htmldjango',
    ['.*%.html%.jinja2'] = 'htmldjango',
    ['.*%.html%.j2'] = 'htmldjango',
  },
}

local group = vim.api.nvim_create_augroup('SecvimTreesitter', { clear = true })

-- Secvim uses native Treesitter highlighting. Neovim 0.12 only bundles
-- parsers for C, Lua, Markdown, Query, Vim, and Vimdoc, so the security
-- stacks (Rust, Python, Go, TS/JS, C/C++, Solidity) are installed below by
-- nvim-treesitter into stdpath('data')/site. Starting a highlighter for a
-- filetype with no parser is harmless: the pcall simply fails.
local has_folds = {}
for _, path in ipairs(vim.api.nvim_get_runtime_file('queries/*/folds.scm', true)) do
  has_folds[vim.fn.fnamemodify(path, ':h:t')] = true
end

local MAX_FILESIZE = 512 * 1024

local function too_big(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name == '' then
    return false
  end
  local ok, stats = pcall(vim.uv.fs_stat, name)
  return ok and stats and stats.size > MAX_FILESIZE or false
end

vim.api.nvim_create_autocmd('FileType', {
  group = group,
  callback = function(args)
    local buf = args.buf
    local lang = vim.treesitter.language.get_lang(args.match)
    if not lang or too_big(buf) then
      return
    end

    if not pcall(vim.treesitter.start, buf, lang) then
      return
    end

    if has_folds[lang] and vim.api.nvim_get_current_buf() == buf then
      vim.wo[0][0].foldmethod = 'expr'
      vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
      vim.wo[0][0].foldlevel = 99
    end
  end,
})

return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
    config = function()
      local parsers = {
        'asm',
        'bash',
        'c',
        'cpp',
        'css',
        'diff',
        'dockerfile',
        'gitcommit',
        'go',
        'html',
        'http',
        'javascript',
        'json',
        'lua',
        'markdown',
        'markdown_inline',
        'python',
        'regex',
        'rust',
        'solidity',
        'sql',
        'toml',
        'tsx',
        'typescript',
        'vim',
        'vimdoc',
        'yaml',
      }

      -- Skip the installer entirely when everything is already present; the
      -- check costs well under a millisecond after the first run.
      local parser_dir = vim.fn.stdpath 'data' .. '/site/parser'
      local missing = false
      for _, lang in ipairs(parsers) do
        if vim.fn.filereadable(parser_dir .. '/' .. lang .. '.so') == 0 then
          missing = true
          break
        end
      end
      if missing then
        require('nvim-treesitter').install(parsers)
      end
    end,
  },
}
