-- https://github.com/liverwust/dotfiles

-- BEGIN neovim and mason and lspconfig boilerplate
require("config.lazy")
require("mason").setup()
require("mason-lspconfig").setup()
-- END neovim and mason and lspconfig boilerplate

-- BEGIN lspconfig setup
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md

-- :MasonInstall powershell-editor-services
if require('mason-registry').is_installed('powershell-editor-services') then
  vim.lsp.enable('powershell_es')
end

-- :MasonInstall jedi-language-server
if require('mason-registry').is_installed('jedi-language-server') then
  vim.lsp.config('jedi_language_server', {
    root_dir = vim.fs.root(0, '.git'),
    init_options = {
      workspace = {
        extraPaths = {
          "/u/wk/lwust/.ansible/collections"
        }
      }
    }
  })
  vim.lsp.enable('jedi_language_server')

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
  vim.lsp.enable('gopls')
end

-- :MasonInstall pyright
if require('mason-registry').is_installed('pyright') then
  vim.lsp.config('pyright', {
    settings = {
      python = {
        analysis = {
          extraPaths = {
            "/u/wk/lwust/.ansible/collections"
          }
        }
      }
    }
  })
  vim.lsp.enable('pyright')
end

-- :MasonInstall ansible-language-server
if require('mason-registry').is_installed('ansible-language-server') then
--  vim.lsp.config('ansiblels', {
--    settings = {
--      ansible = {
--        validation = {
--          enabled = true,
--          lint = {
--            enabled = true
--          }
--	}
--      }
--    }
--  })
--  vim.lsp.enable('ansiblels')
end

-- :MasonInstall zls
if require('mason-registry').is_installed('zls') then
  vim.lsp.enable('zls')
end

local linters = {}

-- :MasonInstall pylint
-- . ~/.local/share/nvim/mason/packages/pylint/venv/bin/activate
-- pip install pylint-venv
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

-- :MasonInstall typescript-language-server
if require('mason-registry').is_installed('typescript-language-server') then
  vim.lsp.enable('ts_ls')
end

-- END lspconfig setup

-- BEGIN telescope setup boilerplate
-- https://github.com/nvim-telescope/telescope.nvim?tab=readme-ov-file
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.git_files, { desc = 'Telescope find (git) files' })
vim.keymap.set('n', '<leader>fg', function()
  builtin.live_grep({
    cwd = '/u/wk/lwust/Repositories',
    search_dirs = {
      "certificate-vault",
      "ess_ansible_RH8",
      "nas_ess.applications",
      "nas_ess.business",
      "nas_ess.database",
      "nas_ess.fips",
      "nas_ess.infra",
      "nas_ess.mail",
      "nas_ess.monitoring",
      "nas_ess.system",
      "nas_ess.user_config",
      "nas_ess.web"
    }
  })
  end,
  { desc = 'Telescope live grep' }
)
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
-- END telescope setup boilerplate

-- BEGIN harpoon setup boilerplate
-- https://github.com/ThePrimeagen/harpoon/tree/harpoon2
local harpoon = require("harpoon")
harpoon:setup()
local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
  local file_paths = {}
  for _, item in ipairs(harpoon_files.items) do
    table.insert(file_paths, item.value)
  end
  require("telescope.pickers").new({}, {
    prompt_title = "Harpoon",
    finder = require("telescope.finders").new_table({
      results = file_paths,
    }),
    previewer = conf.file_previewer({}),
    sorter = conf.generic_sorter({}),
  }):find()
end
vim.keymap.set("n", "<Leader>ha", function() harpoon:list():add() end)
vim.keymap.set("n", "<Leader>hc", function() harpoon:list():clear() end)
vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end)
vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
vim.keymap.set("n", "<Leader>hp", function() harpoon:list():prev() end)
vim.keymap.set("n", "<Leader>hn", function() harpoon:list():next() end)
-- END harpoon setup boilerplate

-- BEGIN source vimrc boilerplate
if vim.fn.has('win32') == 0 then
  vim.cmd('source ~/.vimrc')
else
  vim.cmd('source ~/_vimrc')
end
-- END source vimrc boilerplate

-- BEGIN nvim-specific editor configuration

-- Hacky way to fix the Neovim start menu item PWD
if vim.call('has', 'win32') and vim.call('getcwd') == "C:\\Program Files\\Neovim\\bin"
then
  vim.api.nvim_set_current_dir(vim.env.HOME)
end

-- Set up my preferred colorscheme
if vim.o.termguicolors then
  vim.cmd('colorscheme solarized8')
else
  vim.cmd('colorscheme solarized')
end

-- Automatically detect some hard-to-detect filetypes
vim.api.nvim_create_augroup('Filetypes_Detect', { clear = true })
vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
  group = 'Filetypes_Detect',
  pattern = '*/playbooks/*.yml',
  desc = 'Detect Ansible playbooks based on a filename pattern',
  callback = function()
    vim.opt_local.filetype = 'yaml.ansible'
  end
})

-- Change basic parameters like tabs vs. spaces, width, etc.
function text_params(expandtab, tabwidth, textwidth)
  vim.opt_local.expandtab   = expandtab
  vim.opt_local.shiftwidth  = tabwidth
  vim.opt_local.softtabstop = tabwidth
  vim.opt_local.textwidth   = textwidth
end
function auto_text_params(pattern, expandtab, tabwidth, textwidth)
  vim.api.nvim_create_autocmd('FileType', {
    group = 'Filetypes',
    pattern = pattern,
    desc = 'Set up tabs/spaces/width for filetype ' .. pattern,
    callback = function()
      text_params(expandtab, tabwidth, textwidth)
    end
  })
end
vim.api.nvim_create_augroup('Filetypes', { clear = true })
auto_text_params('css',        true,  2, 0 )
auto_text_params('html',       true,  2, 0 )
auto_text_params('htmldjango', true,  2, 0 )
auto_text_params('javascript', true,  2, 0 )
auto_text_params('json',       true,  2, 0 )
auto_text_params('lua',        true,  2, 0 )
auto_text_params('markdown',   true,  2, 72)
auto_text_params('mermaid',    true,  2, 0 )
auto_text_params('python',     true,  4, 78)
auto_text_params('text',       false, 8, 72)
auto_text_params('vb',         true,  4, 0 )
auto_text_params('vim',        true,  2, 0 )
auto_text_params('yaml',       true,  2, 0 )

-- Some not-so-basic params for specific filetypes
vim.api.nvim_create_augroup('Filetypes_Extra', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'Filetypes_Extra',
  pattern = 'yaml',
  desc = 'Turn off incompatible autoindent for YAML files',
  callback = function()
    vim.opt_local.autoindent = false
  end
})
vim.api.nvim_create_augroup('Filetypes_Extra', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'Filetypes_Extra',
  pattern = 'json',
  desc = 'Set up appropriate folding and formatting for JSON files',
  callback = function()
    vim.opt_local.formatoptions = 'tcq2l'
    vim.opt_local.foldmethod    = 'syntax'
  end
})
vim.api.nvim_create_augroup('Filetypes_Extra', { clear = true })
vim.api.nvim_create_autocmd('FileType', {
  group = 'Filetypes_Extra',
  pattern = 'markdown',
  desc = 'Override the GLOBAL memory limit when editing markdown files',
  callback = function()
    -- https://github.com/vim/vim/issues/5880
    -- E363 seen when opening markdown or using the square left bracket.
    vim.opt_global.maxmempattern = 100000
    vim.opt_local.foldmethod    = 'syntax'
  end
})

-- Easy access to Neovim config files
-- Reference the version in g:dotfiles to allow fugitive to work
-- (vs. looking for ~/.config/nvim/init.lua or others like it)
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

-- Use fugitive to interact with the root/topdir of the working directory
function fugitive_buf_set_keymap(keys, prefix, suffix, desc)
  vim.api.nvim_create_autocmd('BufEnter', {
    group = 'BufInsideGitRepo',
    pattern = '*',
    desc = desc .. ' to the top of the Git working directory',
    callback = function()
      vim.api.nvim_buf_set_keymap(
        0,
        'n',
        '<Leader>' .. keys,
        ':' .. prefix .. vim.call('FugitiveFind', ':(top)') .. suffix,
        { noremap = true }
      )
    end
  })
end
vim.api.nvim_create_augroup('BufInsideGitRepo', { clear = true })
fugitive_buf_set_keymap('gcd', 'cd ', '', 'Change directory')
fugitive_buf_set_keymap('ge',  'e ',  '', 'Edit a file relative')
fugitive_buf_set_keymap(
  'gx',
  'echo system("cd ',
  '; bin/CHANGEME.sh")',
  'Execute a script relative'
)

-- https://www.reddit.com/r/neovim/comments/10hmb6r/inspecting_error_and_warnings_in_details/
-- Show the actual error text for a linter failure in a popup window
vim.api.nvim_set_keymap(
  'n',
  'gl',
  '<cmd> lua vim.diagnostic.open_float()<CR>',
  { noremap = true }
)

-- vim-table-mode use Markdown compatible tables
vim.g.table_mode_corner = '|'

-- https://github.com/moll/vim-bbye
vim.api.nvim_set_keymap(
  'n',
  '<Leader>q',
  ':Bdelete<cr>',
  { noremap = true }
)

-- https://github.com/arouene/vim-ansible-vault
vim.api.nvim_set_keymap(
  'n',
  '<Leader>av',
  ':AnsibleVault<cr>',
  { noremap = true }
)

-- https://github.com/arouene/vim-ansible-vault
vim.api.nvim_set_keymap(
  'n',
  '<Leader>au',
  ':AnsibleUnvault<cr>',
  { noremap = true }
)

-- END nvim-specific editor configuration

-- BEGIN VSCode-Neovim specific configuration

-- Fixup gq when editing Jupyter cells and otherwise
-- https://github.com/vscode-neovim/vscode-neovim/issues/1627
if vim.g.vscode then
  vim.api.nvim_del_keymap(
    'n',
    'gq'
  )
  vim.api.nvim_del_keymap(
    'n',
    'gqq'
  )
end

-- END VSCode-Neovim specific configuration

-- BEGIN Neovide specific configuration

if vim.g.neovide then
  -- I mean, animations are cool, but a bit distracting...
  -- https://neovide.dev/faq.html#how-to-turn-off-all-animations
  vim.g.neovide_position_animation_length = 0
  vim.g.neovide_cursor_animation_length = 0.00
  vim.g.neovide_cursor_trail_size = 0
  vim.g.neovide_cursor_animate_in_insert_mode = false
  vim.g.neovide_cursor_animate_command_line = false
  vim.g.neovide_scroll_animation_far_lines = 0
  vim.g.neovide_scroll_animation_length = 0.00
end

-- END Neovide specific configuration
