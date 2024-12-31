" https://github.com/liverwust/dotfiles
" Throughout the file are instances of the string keep_for_tame_vim
" See generate_tame_vim.awk in the root of this repository

" keep_for_tame_vim
set nocompatible
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
set cursorline                 " I love solarized light; but I need this !
set backspace=indent,eol,start " Tell backspace to do its job
set background=light           " Pathological usage of light-mode
set completeopt-=preview       " Not a fan of scratch buffers for omnifunc
syntax enable

" Set the location of the dotfiles repository
" keep_for_tame_vim
if has('win32')
  let g:dotfiles=$HOME.'/Documents/Repositories/dotfiles'
elseif has('win32unix')
  " E.g., git bash when editing a commit
  let g:dotfiles='/c/Users/lwust/Documents/Repositories/dotfiles'
else
  let g:dotfiles=$HOME.'/.homesick/repos/dotfiles'
endif

" Get those 24-bit COLORS if possible
" keep_for_tame_vim
if has("termguicolors")
  set termguicolors
endif

" macOS backspace settings
" keep_for_tame_vim
if has('mac')
  " https://stackoverflow.com/a/53625973/5265820
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
endif

" Windows ctrl-v and powershell settings
" keep_for_tame_vim
if has('win32')
  " Ctrl-V to paste
  inoremap <C-V> <C-R>+
  " PowerShell to run external commands
  set shell=\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\"
endif

" I'm not just big on mouse reporting
" keep_for_tame_vim
if has('mouse')
  set mouse=
endif

" Quick access to common hard-tab/soft-tab conventions
" keep_for_tame_vim
nnoremap <Leader>t8 :set sw=8<CR>:set sts=8<CR>:set noet<CR>
nnoremap <Leader>s8 :set sw=8<CR>:set sts=8<CR>:set et<CR>
nnoremap <Leader>s4 :set sw=4<CR>:set sts=4<CR>:set et<CR>
nnoremap <Leader>s2 :set sw=2<CR>:set sts=2<CR>:set et<CR>

" CTRL_W o works differently from tmux and results in all windows except
" for the current one being closed; disable it entirely
" keep_for_tame_vim
nnoremap <C-w>o <Nop>
nnoremap <C-w><C-O> <Nop>

" Easy access to vimrc
" Reference the version in g:dotfiles to allow fugitive to work
" (vs. looking for ~/.vimrc or ~/_vimrc a.k.a. $MYVIMRC outside the repo)
" keep_for_tame_vim
execute 'nnoremap <Leader>sv :source '.g:dotfiles.'/home/.vimrc<cr>'
execute 'nnoremap <Leader>ev :e '.g:dotfiles.'/home/.vimrc<cr>'
execute 'nnoremap <Leader>dv :e '.g:dotfiles.'<cr>'

" Move to next/previous quickfix list item, e.g. for vimgrep
" keep_for_tame_vim
nnoremap <Leader>[ :cp<cr>
nnoremap <Leader>] :cn<cr>

" trailing whitespace is bad, mmkay?
" keep_for_tame_vim
hi def link CustomTrailingSpace Error
augroup NoTrailingSpace
  autocmd!
  autocmd Syntax python syn match CustomTrailingSpace /\s\+$/
augroup END

" GVim settings
" https://vi.stackexchange.com/a/3104/25883
if has("unix")
    function! FontSizePlus ()
      let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endfunction
    function! FontSizeMinus ()
      let l:gf_size_whole = matchstr(&guifont, '\( \)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ' '.l:gf_size_whole
      let &guifont = substitute(&guifont, ' \d\+$', l:new_font_size, '')
    endfunction
else
    function! FontSizePlus ()
      let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole + 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
    endfunction
    function! FontSizeMinus ()
      let l:gf_size_whole = matchstr(&guifont, '\(:h\)\@<=\d\+$')
      let l:gf_size_whole = l:gf_size_whole - 1
      let l:new_font_size = ':h'.l:gf_size_whole
      let &guifont = substitute(&guifont, ':h\d\+$', l:new_font_size, '')
    endfunction
endif
if has("gui_running")
  if has('unix')
    set guifont=DejaVu\ Sans\ Mono\ 13
  elseif has('win32')
    set guifont=DejaVu_Sans_Mono:h13
  endif
  nnoremap <Leader>- :call FontSizeMinus()<CR>
  nnoremap <Leader>+ :call FontSizePlus()<CR>
  nnoremap <Leader>= :call FontSizePlus()<CR>
  set lines=32
  set guioptions-=T
  set guioptions-=m
  set guioptions-=r
  set guioptions-=R
  set guioptions-=L
endif
