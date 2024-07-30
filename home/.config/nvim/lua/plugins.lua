local plugins = {
  "PProvost/vim-ps1",
  "altercation/vim-colors-solarized",
  "chazmcgarvey/vim-mermaid",
  "dhruvasagar/vim-table-mode",
  "fatih/vim-go",
  "knsh14/vim-github-link",
  "lifepillar/vim-solarized8",
  "liverwust/ansible-vim",
  "m-pilia/vim-mediawiki",
  "moll/vim-bbye",
  "tpope/vim-fugitive",
  "tpope/vim-vinegar",
  "vim-pandoc/vim-pandoc",
  "vim-pandoc/vim-pandoc-syntax",
  "williamboman/mason.nvim",
}
if vim.fn.has('python3') ~= 0 then
  table.insert(plugins, "SirVer/ultisnips")
end
return plugins
