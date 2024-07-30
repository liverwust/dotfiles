require("config.lazy")
if vim.fn.has('win32') == 0 then
  vim.cmd('source ~/.vimrc')
else
  vim.cmd('source ~/_vimrc')
end
