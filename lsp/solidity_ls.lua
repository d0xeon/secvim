local cmd = { 'vscode-solidity-server', '--stdio' }
if vim.fn.executable 'nomicfoundation-solidity-language-server' == 1 then
  cmd = { 'nomicfoundation-solidity-language-server', '--stdio' }
end

return {
  cmd = cmd,
  filetypes = { 'solidity' },
  root_markers = { 'foundry.toml', 'hardhat.config.ts', 'hardhat.config.js', 'truffle-config.js', 'package.json', '.git' },
}
