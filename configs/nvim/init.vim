"general
"set nocompatible
set confirm
set encoding=utf-8

"integration
set noerrorbells

"directories
set directory=~/.config/nvim/swaps
set backupdir=~/.config/nvim/backups
set undodir=~/.config/nvim/undos
set tags=./tags;,tags;
set clipboard=unnamed,unnamedplus
set swapfile

"window
set cursorline
set number
set ruler
set wrap
set list
set listchars=tab:▸\ ,trail:-

"indent
set backspace=2
set autoindent
set smartindent
set tabstop=4
set shiftwidth=2
set smarttab
set expandtab

"show
set showmatch
set showcmd
set noshowmode

"search
set hlsearch
set ignorecase
set smartcase

"clearly zenkaku space
function! ShowZenkakuSpace()
  highlight ShowZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
endfunction

if has('syntax')
  augroup ShowZenkakuSpace
    autocmd!
    autocmd ColorScheme * call ShowZenkakuSpace()
    autocmd VimEnter,WinEnter,BufRead * let w:m1=matchadd('ShowZenkakuSpace', '　')
  augroup END
  call ShowZenkakuSpace()
endif

"dein Scripts-----------------------------
" Required:
set runtimepath+=~/.vim/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('~/.vim/dein')
  call dein#begin('~/.vim/dein')

  " Let dein manage dein
  " Required:
  call dein#add('~/.vim/dein/repos/github.com/Shougo/dein.vim')

  " editorconfig
  call dein#add('editorconfig/editorconfig-vim')

  " neosnippets
  call dein#add('Shougo/neosnippet.vim')
  call dein#add('Shougo/neosnippet-snippets')

  " fish highlighting
  call dein#add('dag/vim-fish')

  " molokai theme
  call dein#add('tomasr/molokai')

  " Required:
  call dein#end()
  call dein#save_state()
endif

" Required:
filetype plugin indent on
syntax enable
colorscheme molokai

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------

" Local config
if filereadable($HOME . "/.config/nvim/init.vim.local")
  source ~/.config/nvim/init.vim.local
endif

