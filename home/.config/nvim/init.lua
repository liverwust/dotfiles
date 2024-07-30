if vim.fn.has('win32') then
  vim.cmd('source ~/_vimrc')
else
  vim.cmd('source ~/.vimrc')
end
require("config.lazy")
