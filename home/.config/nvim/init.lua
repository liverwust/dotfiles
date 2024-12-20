-- BEGIN neovim and mason and lspconfig boilerplate
require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()
-- END neovim and mason and lspconfig boilerplate

-- BEGIN lspconfig setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- :MasonInstall powershell-editor-services
if require('mason-registry').is_installed('powershell-editor-services') then
  require'lspconfig'.powershell_es.setup{}
end

-- :MasonInstall jedi-language-server
if require('mason-registry').is_installed('jedi-language-server') then
  require'lspconfig'.jedi_language_server.setup{
    root_dir = require'lspconfig'.util.find_git_ancestor,
    init_options = {
      workspace = {
        extraPaths = {
          "/u/wk/lwust/.ansible/collections"
        }
      }
    }
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

-- :MasonInstall pyright
if require('mason-registry').is_installed('pyright') then
  require'lspconfig'.pyright.setup{
    settings = {
      python = {
        analysis = {
          extraPaths = {
            "/u/wk/lwust/.ansible/collections"
          }
        }
      }
    }
  }
end

-- :MasonInstall ansible-language-server
if require('mason-registry').is_installed('ansible-language-server') then
  require'lspconfig'.ansiblels.setup{}
end

local linters = {}

-- :MasonInstall pylint
if require('mason-registry').is_installed('pylint') then
  linters.python = {'pylint',}
end

require('lint').linters_by_ft = linters
vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  callback = function()

    -- try_lint without arguments runs the linters defined in `linters_by_ft`
    -- for the current filetype
    require("lint").try_lint()

    -- You can call `try_lint` with a linter name or a list of names to always
    -- run specific linters, independent of the `linters_by_ft` configuration
    --require("lint").try_lint("cspell")
  end,
})

-- END lspconfig setup

-- BEGIN source vimrc boilerplate
if vim.fn.has('win32') == 0 then
  vim.cmd('source ~/.vimrc')
else
  vim.cmd('source ~/_vimrc')
end
-- END source vimrc boilerplate

-- BEGIN nvim-specific editor configuration
vim.api.nvim_set_keymap(
    'n',
    '<Leader>ep',
    ':e ' .. vim.g.dotfiles .. '/home/.config/nvim/lua/plugins.lua<cr>',
    { noremap = true }
)
vim.api.nvim_set_keymap(
    'n',
    '<Leader>ei',
    ':e ' .. vim.g.dotfiles .. '/home/.config/nvim/init.lua<cr>',
    { noremap = true }
)
-- END nvim-specific editor configuration
