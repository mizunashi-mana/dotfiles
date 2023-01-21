"general
set nocompatible
set confirm
set encoding=utf-8

"integration
set noerrorbells

"directories
call mkdir($HOME . "/.local/var/nvim/swaps", "p")
set directory=~/.local/var/nvim/swaps
call mkdir($HOME . "/.local/var/nvim/backups", "p")
set backupdir=~/.local/var/nvim/backups
call mkdir($HOME . "/.local/var/nvim/undos", "p")
set undodir=~/.local/var/nvim/undos
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
set wrapscan

"indent
set backspace=indent,eol,start
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

"filetype associations
au BufRead,BufNewFile */.ssh/conf.d/*.conf set filetype=sshconfig
au BufRead,BufNewFile */git/config* set filetype=gitconfig

"dein Scripts-----------------------------
" Set dein base path (required)
let s:dein_base = '~/.local/var/nvim/dein'

" Set dein source path (required)
let s:dein_src = '~/.local/share/dein/repos/github.com/Shougo/dein.vim'

" Set dein runtime path (required)
execute 'set runtimepath+=' . s:dein_src

" Call dein initialization (required)
call dein#begin(s:dein_base)

call dein#add(s:dein_src)

" editorconfig
call dein#add('editorconfig/editorconfig-vim')

" neosnippets
call dein#add('Shougo/neocomplete.vim')
call dein#add('Shougo/neosnippet.vim')
call dein#add('Shougo/neosnippet-snippets')

" fish highlighting
call dein#add('dag/vim-fish')

" molokai theme
call dein#add('tomasr/molokai')

" auto paste mode
call dein#add('ConradIrwin/vim-bracketed-paste')

" toml support
call dein#add('cespare/vim-toml')

" Finish dein initialization (required)
call dein#end()

" Required:
filetype plugin indent on
if has('syntax')
  syntax on
endif
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
