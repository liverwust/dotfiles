require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- :MasonInstall powershell-editor-services
if require('mason-registry').is_installed('powershell-editor-services') then
  require'lspconfig'.powershell_es.setup{}
end

if vim.fn.has('win32') == 0 then
  vim.cmd('source ~/.vimrc')
else
  vim.cmd('source ~/_vimrc')
end
