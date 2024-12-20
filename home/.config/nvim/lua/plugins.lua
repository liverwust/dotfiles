local plugins = {
  "PProvost/vim-ps1",
  "altercation/vim-colors-solarized",
  "chazmcgarvey/vim-mermaid",
  "dhruvasagar/vim-table-mode",
  "knsh14/vim-github-link",
  "lifepillar/vim-solarized8",
  "liverwust/ansible-vim",
  "m-pilia/vim-mediawiki",
  "mfussenegger/nvim-lint",
  "michaeljsmith/vim-indent-object",
  "moll/vim-bbye",
  "neovim/nvim-lspconfig",
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
}
if vim.fn.has('python3') ~= 0 then
  table.insert(plugins, "SirVer/ultisnips")
end
return plugins
