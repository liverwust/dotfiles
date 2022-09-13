" Louis Wust's vimrc
" 2022-02-05

set nocompatible

" Use non-legacy SnipMate parser
let g:snipMate = { 'snippet_version' : 1 }

filetype off                  " required
set runtimepath+=~/.homesick/repos/dotvim/vim
if has('packages')
  set packpath+=~/.homesick/repos/dotvim/vim
  if has('nvim')
    "Isolate vim-ghost, which causes an error on Vim 7.9
    set packpath+=~/.homesick/repos/dotvim/nvim-only-packages
  endif
else
  source ~/.homesick/repos/dotvim/vim-pathogen/autoload/pathogen.vim
  execute pathogen#infect()
endif
"Plugin 'm-pilia/vim-mediawiki'
if has('nvim')
  let g:ghost_darwin_app = 'iTerm2'
  let g:ghost_autostart = 1
endif
" All of your Plugins must be added before the following line
filetype plugin indent on

set visualbell                 " Use visual bell instead of beeping
set showcmd                    " Show (partial) command in status line
set showmatch                  " Show matching brackets
set ignorecase                 " Do case insensitive matching
set smartcase                  " Do smart case matching
set incsearch                  " Incremental search
set shiftround                 " Round indent to multiple of 'shiftwidth'
set autoindent                 " Copy indent from current line to new line
set ruler                      " Show current file position in lower-right
set splitright                 " :vsplit new window on the right, not left
set backspace=indent,eol,start " Tell backspace to do its job
colorscheme solarized
nnoremap <Leader>xw :%s/\s\+$//<cr>

" Use this at home (Vim 8). Comment it out for work (Vim 7).
" packadd! matchit " makes the % command work better

syntax enable

" GVim settings
if has('gui_running')
  if has('win32')
    " Windows setup
    set guifont=Anonymous_Pro:h14
    set lines=32
  elseif hostname() == "ldt-4054622.gfdl.noaa.gov"
    " Work & 4K monitor
    set guifont=DejaVu\ Sans\ Mono\ 18
    set lines=50
  else
    " Linux (or other) setup
    set guifont=DejaVu\ Sans\ Mono\ 13
    set lines=32
  endif
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=R
  set guioptions-=L
endif

" straight from Vim's map.txt
function! s:SID()
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfun

" change basic parameters like tabs vs. spaces, width, etc.
function! s:TextParams(hardtab, tabwidth, textwidth)
  if a:hardtab
    let &l:expandtab = 0
  else
    let &l:expandtab = 1
  endif
  let &l:shiftwidth = a:tabwidth
  let &l:softtabstop = a:tabwidth
  let &l:textwidth = a:textwidth
endfunction

augroup Filetypes
  autocmd!
  autocmd FileType text       call <SID>TextParams(1, 8, 72)
  autocmd FileType vim        call <SID>TextParams(0, 2, 0)
  autocmd FileType python     call <SID>TextParams(0, 4, 78)
  autocmd FileType htmldjango call <SID>TextParams(0, 2, 0)
  autocmd FileType html       call <SID>TextParams(0, 2, 0)
  autocmd FileType css        call <SID>TextParams(0, 2, 0)
  autocmd FileType javascript call <SID>TextParams(0, 2, 0)
  autocmd FileType vb         call <SID>TextParams(0, 4, 0)
  autocmd FileType markdown   call <SID>TextParams(0, 2, 72)
  autocmd FileType yaml       call <SID>TextParams(0, 2, 0)
  autocmd FileType yaml       setlocal noautoindent
  autocmd FileType json       call <SID>TextParams(0, 2, 0)
  autocmd FileType json       setlocal formatoptions=tcq2l
  autocmd FileType json       setlocal foldmethod=syntax
augroup END

" trailing whitespace is bad, mmkay?
hi def link CustomTrailingSpace Error
augroup NoTrailingSpace
  autocmd!
  autocmd Syntax python syn match CustomTrailingSpace /\s\+$/
augroup END

" Settings for common textfields that I want to edit in Vim using GhostText,
" rather than directly in the browser
if has('nvim')
  augroup GhostText
    autocmd!
    " BMC Remedy ticket descriptions, replies, etc.
    autocmd BufNewFile,BufRead /var/folders/*/ghost-remedy*.txt set textwidth=0
    autocmd BufNewFile,BufRead /var/folders/*/ghost-remedy*.txt set syntax=mail
    " ESS Wiki
    autocmd BufNewFile,BufRead /var/folders/*/ghost-in*esswiki*.txt set textwidth=0
    autocmd BufNewFile,BufRead /var/folders/*/ghost-in*esswiki*.txt set syntax=mediawiki
  augroup END
endif

" xsel clipboard commands
if executable("xsel") == 1
  function! <SID>DoXCopy()
    let xsel_contents = getreg("")
    call system("xsel -ib", xsel_contents)
  endfunction
  function! <SID>DoXPaste()
    let xsel_contents = system("xsel -ob")
    if stridx(xsel_contents, "\n") >= 0
      let reg_mode = "l"
    else
      let reg_mode = "c"
    endif
    call setreg("", xsel_contents, reg_mode)
  endfunction
  command! XCopy call <SID>DoXCopy()
  command! XPaste call <SID>DoXPaste()
endif

" https://vi.stackexchange.com/questions/14829/close-multiple-buffers-interactively
function! <SID>InteractiveBufDelete()
  let l:prompt = "Specify buffers to delete: "

  ls | let bufnums = input(l:prompt)
  while strlen(bufnums)
    echo "\n"
    let buflist = split(bufnums)
    for bufitem in buflist
      if match(bufitem, '^\d\+,\d\+$') >= 0
        exec ':' . bufitem . 'bd'
      elseif match(bufitem, '^\d\+$') >= 0
        exec ':bd ' . bufitem
      else
        echohl ErrorMsg | echo 'Not a number or range: ' . bufitem | echohl None
      endif 
    endfor
    ls | let bufnums = input(l:prompt)
  endwhile 

endfunction
nnoremap <silent> <leader>bd :call <SID>InteractiveBufDelete()<CR>

" https://github.com/moll/vim-bbye
nnoremap <Leader>q :Bdelete<CR>

" Quick access to common hard-tab/soft-tab conventions
nnoremap <Leader>t8 :set sw=8<CR>:set sts=8<CR>:set noet<CR>
nnoremap <Leader>s8 :set sw=8<CR>:set sts=8<CR>:set et<CR>
nnoremap <Leader>s4 :set sw=4<CR>:set sts=4<CR>:set et<CR>
nnoremap <Leader>s2 :set sw=2<CR>:set sts=2<CR>:set et<CR>

" Open a gnome-terminal in the directory of the current file
nnoremap <Leader>term :!gnome-terminal --working-directory=%:p:h<CR>

" Remove <span> tags generated by Pandoc in mediawiki output
nnoremap <Leader>ds :%g/<span id="[^"]\+"><\/span>$/d<CR>

" https://shapeshed.com/vim-netrw/
let g:netrw_banner = 0

" CTRL_W o works differently from tmux and results in all windows except
" for the current one being closed; disable it entirely
nnoremap <C-w>o <Nop>
nnoremap <C-w><C-O> <Nop>

" https://pragprog.com/titles/dnvim2/practical-vim-second-edition/
cnoremap <expr> %%  getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" https://github.com/fatih/vim-go/blob/master/doc/vim-go.txt
let g:go_code_completion_enabled = 0
let g:go_fmt_autosave = 0
let g:go_mod_fmt_autosave = 0
let g:go_asmfmt_autosave = 0
let g:go_metalinter_autosave = 0
let g:go_imports_autosave = 0
