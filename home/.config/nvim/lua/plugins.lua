local plugins = {
  "PProvost/vim-ps1",
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" }
  },
  "altercation/vim-colors-solarized",
  "arouene/vim-ansible-vault",
  "chazmcgarvey/vim-mermaid",
  "dhruvasagar/vim-table-mode",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/nvim-cmp",
  "j-hui/fidget.nvim",
  "knsh14/vim-github-link",
  "lilyinstarlight/vim-spl",
  "liverwust/ansible-vim",
  "m-pilia/vim-mediawiki",
  "mfussenegger/nvim-lint",
  "michaeljsmith/vim-indent-object",
  "moll/vim-bbye",
  "neovim/nvim-lspconfig",
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      'nvim-lua/plenary.nvim'
    }
  },
  {
    -- https://github.com/scalameta/nvim-metals
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    opts = function()
      local metals_config = require("metals").bare_config()
      metals_config.init_options.statusBarProvider = "off"
      metals_config.on_attach = function(client, bufnr)
        -- LSP mappings
        vim.keymap.set("n", "gD", vim.lsp.buf.definition)
        vim.keymap.set("n", "K", vim.lsp.buf.hover)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation)
        vim.keymap.set("n", "gr", vim.lsp.buf.references)
        vim.keymap.set("n", "gds", vim.lsp.buf.document_symbol)
        vim.keymap.set("n", "gws", vim.lsp.buf.workspace_symbol)
        vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run)
        vim.keymap.set("n", "<leader>sh", vim.lsp.buf.signature_help)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)

        vim.keymap.set("n", "<leader>ws", function()
          require("metals").hover_worksheet()
        end)

        -- all workspace diagnostics
        vim.keymap.set("n", "<leader>aa", vim.diagnostic.setqflist)

        -- all workspace errors
        vim.keymap.set("n", "<leader>ae", function()
          vim.diagnostic.setqflist({ severity = "E" })
        end)

        -- all workspace warnings
        vim.keymap.set("n", "<leader>aw", function()
          vim.diagnostic.setqflist({ severity = "W" })
        end)

        -- buffer diagnostics only
        vim.keymap.set("n", "<leader>d", vim.diagnostic.setloclist)

        vim.keymap.set("n", "[c", function()
          vim.diagnostic.goto_prev({ wrap = false })
        end)

        vim.keymap.set("n", "]c", function()
          vim.diagnostic.goto_next({ wrap = false })
        end)
      end

      return metals_config
    end,
    config = function(self, metals_config)
      local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        pattern = self.ft,
        callback = function()
          require("metals").initialize_or_attach(metals_config)
        end,
        group = nvim_metals_group,
      })
    end
  },
  "tpope/vim-commentary",
  "tpope/vim-fugitive",
  "tpope/vim-repeat",
  "tpope/vim-surround",
  "tpope/vim-vinegar",
  "vim-pandoc/vim-pandoc",
  "vim-pandoc/vim-pandoc-syntax",
  "vim-scripts/vim-soy",
  "williamboman/mason-lspconfig.nvim",
  "williamboman/mason.nvim",
  {
    "lifepillar/vim-solarized8",
    branch = "neovim"
  },
}
if vim.fn.has('python3') ~= 0 then
  table.insert(plugins, "SirVer/ultisnips")
end
return plugins
