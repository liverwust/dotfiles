" Throughout the file are instances of the string "keep_for_tame_vim"
" See generate_tame_vim.awk in the root of this repository

" keep_for_tame_vim
set nocompatible

" Set the location of the dotvim repository
if has('win32')
  let g:dotvim=$HOME.'/Documents/Repositories/dotvim'
elseif has('win32unix')
  " E.g., git bash when editing a commit
  let g:dotvim='/c/Users/lwust/Documents/Repositories/dotvim'
else
  let g:dotvim=$HOME.'/.homesick/repos/dotvim'
endif

if !has('nvim')
  filetype off
  execute 'source '.g:dotvim.'/vim-pathogen/autoload/pathogen.vim'
  " Consider restricted submodules, which should be conditionally loaded
  if has("python3")
    let g:UltiSnipsSnippetDirectories=[g:dotvim.'/vim/UltiSnips']
    execute pathogen#infect(g:dotvim.'/restricted-submodules/vim-ultisnips')
  endif
  if has('patch-8.1.2269')
    execute pathogen#infect(g:dotvim.'/restricted-submodules/vim-go')
  endif
  execute pathogen#infect('bundle/{}', g:dotvim.'/{}')
  let &runtimepath=g:dotvim.'/vim,'.&runtimepath
endif

" keep_for_tame_vim
filetype plugin indent on

" keep_for_tame_vim
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
syntax enable

if has("termguicolors") && $TMUX==""
  " Get those 24-bit COLORS
  set termguicolors
  colorscheme solarized8
else
  colorscheme solarized
endif

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

" GVim settings
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

" macOS settings
if has('mac')
  " https://stackoverflow.com/a/53625973/5265820
  let &t_ZH="\e[3m"
  let &t_ZR="\e[23m"
endif

" Windows settings
if has('win32')
  " Ctrl-V to paste
  inoremap <C-V> <C-R>+
  " PowerShell to run external commands
  set shell=\"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe\"
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
  " https://github.com/vim/vim/issues/5880
  " E363 seen when opening markdown or using the square left bracket.
  autocmd FileType markdown   set maxmempattern=100000
  autocmd FileType yaml       call <SID>TextParams(0, 2, 0)
  autocmd FileType yaml       setlocal noautoindent
  autocmd FileType json       call <SID>TextParams(0, 2, 0)
  autocmd FileType json       setlocal formatoptions=tcq2l
  autocmd FileType json       setlocal foldmethod=syntax
  autocmd FileType mermaid    call <SID>TextParams(0, 2, 0)
augroup END

" trailing whitespace is bad, mmkay?
hi def link CustomTrailingSpace Error
augroup NoTrailingSpace
  autocmd!
  autocmd Syntax python syn match CustomTrailingSpace /\s\+$/
augroup END

augroup VimGoCustomization
  autocmd!
  " https://github.com/fatih/vim-go/issues/3497
  if (has('balloon_eval') && has('gui_running')) || has('balloon_eval_term')
    set ballooneval
    autocmd FileType go setlocal balloonexpr=go#tool#DescribeBalloon()
  endif
  if has('popupwin')
     let g:go_doc_popup_window = 1
  endif
augroup END

" Jedi completion for Python
let g:jedi#popup_on_dot=0
if isdirectory($HOME."/.ansible/collections")
  let g:jedi#added_sys_path=[$HOME."/.ansible/collections"]
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
" Reference the version in g:dotvim to allow fugitive to work
" (vs. looking for ~/.vimrc or ~/_vimrc a.k.a. $MYVIMRC outside the repo)
execute 'nnoremap <Leader>sv :source '.g:dotvim.'/home/.vimrc<cr>'
execute 'nnoremap <Leader>ev :e '.g:dotvim.'/home/.vimrc<cr>'
execute 'nnoremap <Leader>dv :e '.g:dotvim.'<cr>'

" Move to next/previous quickfix list item, e.g. for vimgrep
" keep_for_tame_vim
nnoremap <Leader>[ :cp<cr>
nnoremap <Leader>] :cn<cr>

" Always search using verymagic ("normal" regular expressions)
" https://stackoverflow.com/a/3760486/5265820
" keep_for_tame_vim
nnoremap / /\v
cnoremap %s/ %s/\v
