require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()

-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- :MasonInstall powershell-editor-services
if require('mason-registry').is_installed('powershell-editor-services') then
  require'lspconfig'.powershell_es.setup{}
end

-- :MasonInstall jedi-language-server
if require('mason-registry').is_installed('jedi-language-server') then
  vim.lsp.set_log_level('debug')
  require'lspconfig'.jedi_language_server.setup{
    root_dir = require'lspconfig'.util.find_git_ancestor
  }

  -- Don't let python3complete override LSP
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if client.server_capabilities.completionProvider then
        vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
      end
      if client.server_capabilities.definitionProvider then
        vim.bo[bufnr].tagfunc = "v:lua.vim.lsp.tagfunc"
      end
    end
  })
end

-- go install golang.org/x/tools/gopls@latest
if vim.fn.executable("gopls") == 1 then
  require'lspconfig'.gopls.setup{}
end

if vim.fn.has('win32') == 0 then
  vim.cmd('source ~/.vimrc')
else
  vim.cmd('source ~/_vimrc')
end
