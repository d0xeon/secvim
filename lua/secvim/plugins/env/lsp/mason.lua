local mason_bin = vim.fn.stdpath 'data' .. '/mason/bin'
if not vim.env.PATH:find(mason_bin, 1, true) then
  vim.env.PATH = mason_bin .. ':' .. vim.env.PATH
end

-- Capabilities are registered by blink.cmp itself (plugin/blink-cmp.lua calls
-- vim.lsp.config('*', ...) on load); blink is non-lazy so this happens before
-- the first server starts.
vim.lsp.enable {
  'tsc',
  -- vtsls is temporary, Vue projects only. Removal checklist in lsp/vtsls.lua
  'vtsls',
  'vue_language_server',
  'tailwindcss',
  'emmet_ls',
  'basedpyright',
  'ruff',
  'intelephense',
  'jsonls',
  'gopls',
  'rust_analyzer',
  'clangd',
  'sqlls',
  'lua_ls',
  'css_lsp',
  'superhtml',
  'marksman',
  'solidity_ls',
  'bashls',
  'yamlls',
  'taplo',
}

return {
  {
    'williamboman/mason.nvim',
    cmd = 'Mason',
    opts = {
      ui = {
        border = 'rounded',
        icons = {
          package_installed = '󰄳',
          package_pending = '󰦗',
          package_uninstalled = '󰅙',
        },
      },
    },
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate', 'MasonToolsClean' },
    opts = {
      run_on_start = false,
      ensure_installed = {
        -- LSP Servers
        'tsc',
        'vtsls',
        'vue-language-server',
        'tailwindcss-language-server',
        'css-lsp',
        'emmet-ls',
        'superhtml',
        'basedpyright',
        'ruff',
        'intelephense',
        'json-lsp',
        'gopls',
        'rust-analyzer',
        'clangd',
        'sqlls',
        'lua-language-server',
        'marksman',
        'vscode-solidity-server',
        'nomicfoundation-solidity-language-server',
        'bash-language-server',
        'yaml-language-server',
        'taplo',
        -- Formatters
        'stylua',
        'prettierd',
        'autopep8',
        'ruff',
        'clang-format',
        'sql-formatter',
        'blade-formatter',
        'goimports',
        'shfmt',
        -- Linters
        'djlint',
        'biome',
        'mypy',
        'eslint_d',
        'solhint',
        'shellcheck',
        -- Debuggers
        'php-debug-adapter',
        'go-debug-adapter',
        'debugpy',
        'codelldb',
        'js-debug-adapter',
      },
    },
    dependencies = {
      'williamboman/mason.nvim',
    },
  },
}
