
" Vim needs a POSIX-Compliant shell. Fish is not.
set shell=/bin/bash

" Leader key
let mapleader="ñ"

set nocompatible              " be iMproved, required
filetype off                  " required

" Vundle as plugin manager
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Let Vundle manage itself.
Plugin 'VundleVim/Vundle.vim'

" Plugin configuration
Plugin 'tpope/vim-surround'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-repeat'
Plugin 'ctrlpvim/ctrlp.vim'
" Color scheme
"Plugin 'sjl/badwolf'
Plugin 'morhetz/gruvbox'

call vundle#end()

" General configuration
filetype plugin indent on
set history=1000
set autoread
set number
set ruler
set cursorline
set so=7
set wildmenu
set wildmode=list:longest
set wildignore=*.o,*~,*.pyc
set wildignore+=*/node_modules/**
set wildignore+=*/bower_components/**
set backspace=eol,start,indent
set ignorecase
set smartcase
set hlsearch
set incsearch
set lazyredraw
set magic
set showmatch
set mat=2
set noerrorbells
set novisualbell
set t_vb=
set tm=500
set list
set listchars=tab:⋅›,trail:⋅,nbsp:⋅
set encoding=utf8
set ffs=unix,dos,mac
set nobackup
set nowb
set noswapfile
set expandtab
set smarttab
set shiftwidth=4
set tabstop=4
set lbr
set tw=120
set ai
set si
set wrap
set laststatus=2
set ttyfast
set mouse=a
set clipboard=unnamed

" Colors
colorscheme gruvbox
syntax enable
set t_Co=256
set background=dark

noremap <Leader>ft :NERDTreeToggle<cr>
nmap <Leader>sh :noh<CR>
nmap <tab> <c-w><c-w>

" Delete trailing whitespaces
func! DeleteTrailing()
exe "normal mz"
%s/\s\+$//ge
exe "normal `z"
endfunc
