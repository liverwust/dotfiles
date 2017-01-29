" Louis Wust's vimrc
" 2016-12-09

set nocompatible

set visualbell  " Use visual bell instead of beeping
set showcmd     " Show (partial) command in status line
set showmatch   " Show matching brackets
set ignorecase  " Do case insensitive matching
set smartcase   " Do smart case matching
set incsearch   " Incremental search
set shiftround  " Round indent to multiple of 'shiftwidth'
set autoindent  " Copy indent from current line when starting a new line 
nnoremap <Leader>sv :source $MYVIMRC<cr>
nnoremap <Leader>xw :%s/\s\+$//<cr>

runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

syntax enable
filetype plugin indent on
colorscheme monokai

" GVim settings
if has('gui_running')
  if has('win32')
    set guifont=Anonymous_Pro:h16
  else
    set guifont=DejaVu\ Sans\ Mono\ 16
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

" hard tabs are often bad
function! <SID>UseSpacesNotTabs(nr_spaces)
  let &l:shiftwidth = a:nr_spaces
  let &l:softtabstop = a:nr_spaces
  let &l:expandtab = 1
endfunction

augroup Filetypes
  autocmd!
  autocmd FileType text   setlocal textwidth=72
  autocmd FileType vim    call <SID>UseSpacesNotTabs(2)
  autocmd FileType python call <SID>UseSpacesNotTabs(4)
  autocmd FileType json   call <SID>UseSpacesNotTabs(2)
  autocmd FileType json   setlocal formatoptions=tcq2l
  autocmd FileType json   setlocal foldmethod=syntax
augroup END

" trailing whitespace is bad, mmkay?
hi def link CustomTrailingSpace Error
augroup NoTrailingSpace
  autocmd!
  autocmd Syntax python syn match CustomTrailingSpace /\s\+$/
augroup END

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

" hierarchical text files -- occasionally useful for braindumps
function! <SID>HierarchicalFoldExpr()
  let l:foldlevel = -1
  " Is this a blank line?
  if getline(v:lnum)=='^$'
    " Yes it is, so use the foldlevel from before or after
    " this line (whichever is lowest)
    let l:foldlevel = -1
  else
    " Line is not blank, so...
    " Does this line have fewer spaces of indent than the
    " next line?
    if indent(v:lnum) < indent(v:lnum+1)
      " If so, then a fold with a level equal to the
      " NEXT line's indent starts at THIS line
      let l:foldlevel = '>'.indent(v:lnum+1)
    else
      " If not, then the fold at this line has a
      " level equal to THIS line's indent
      let l:foldlevel = indent(v:lnum)
    endif
  endif
  return l:foldlevel
endfunction
function! <SID>UseHierarchicalFolds()
  let &l:foldmethod = "expr"
  echo s:SID()
  let &l:foldexpr = "<SNR>" . s:SID() . "_HierarchicalFoldExpr()"
  let &l:foldtext = "getline(v:foldstart)"
  let &l:foldlevel = 99  " open all folds by default
  call <SID>UseSpacesNotTabs(2)
endfunction
command! UseHierarchicalFolds call <SID>UseHierarchicalFolds()
