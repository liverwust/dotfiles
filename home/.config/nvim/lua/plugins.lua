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
