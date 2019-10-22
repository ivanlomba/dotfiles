
if &shell =~# 'fish$'
    set shell=sh
endif

let mapleader="\<Space>"

set nocompatible
filetype off

call plug#begin('~/.config/nvim/plugged')
Plug 'dag/vim-fish'
Plug 'airblade/vim-gitgutter'
Plug 'terryma/vim-expand-region'
Plug 'tpope/vim-commentary'
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-vinegar'
Plug 'tpope/vim-ragtag'
Plug 'wincent/terminus'
if $TERM_PROGRAM =~ "iTerm"
   let g:TerminusAssumeITerm=1
 endif
 let g:TerminusFocusReporting=1
 let g:TerminusBracketedPaste=0
Plug 'morhetz/gruvbox'
Plug 'altercation/vim-colors-solarized'
Plug 'pangloss/vim-javascript'
Plug 'elixir-lang/vim-elixir'
Plug 'tpope/vim-speeddating'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'mxw/vim-jsx'
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'sbdchd/neoformat'
Plug 'neomake/neomake'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'duggiefresh/vim-easydir'
Plug 'tpope/vim-abolish'
Plug 'dense-analysis/ale'

call plug#end()

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
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
set guifont = "ASM Regular" 14

" Colors
"let iterm_profile = $ITERM_PROFILE
" if iterm_profile == "trabeDark"
 "  colorscheme gruvbox
 "  set background=dark
 " else
   colorscheme solarized
   set background=light        " Set solarized background color
 " endif

set t_Co=256
syntax enable
" let g:solarized_termcolors=256

" Status bar
let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo', 'percent' ],
      \             [ 'filetype' ] ]
      \ },
      \ 'component': {
      \   'readonly': '%{&filetype=="help"?"":&readonly?"⭤":""}',
      \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      \ },
      \ 'component_visible_condition': {
      \   'readonly': '(&filetype!="help"&& &readonly)',
      \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      \ }
      \ }

" Key mappings
nnoremap <leader>ev :tabedit $MYVIMRC<cr>

nnoremap <leader>fp :tabedit<cr>
nnoremap <leader>fb :tabprevious<cr>
nnoremap <leader>fn :tabnext<cr>

nnoremap <leader>vc :source $MYVIMRC<cr>

noremap <leader>bd :bd<cr>
noremap <leader>ft :NERDTreeToggle<cr>
noremap <leader>fi :NERDTreeFind<cr>

noremap <leader>ff :FZF<cr>

noremap <leader><BS> :noh<cr>
nmap <tab> <c-w><c-w>

nmap <c-p> :Files<cr>
nmap <c-b> :Buffers<cr>

tnoremap <esc> <C-\><C-n>

" navigation on eslint errors
nmap <silent> <leader>en :ALENext<cr>
nmap <silent> <leader>ep :ALEPrevious<cr>

" edit/source vim config
nnoremap <leader> ev :e $MYVIMRC<cr>

" supertab and deoplete tuning
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:deoplete#enable_at_startup=1
let g:deoplete#enable_smart_case=1

" File config
au FileType gitcommit set tw=72
au FileType javascript setlocal ts=2 sw=2 expandtab
let g:jsx_ext_required = 0
au FileType go setlocal ts=4 sw=4 expandtab
au FileType lua setlocal ts=2 sw=2 expandtab
autocmd FileType html :setlocal sw=2 ts=2 sts=2
autocmd BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab
autocmd BufWrite *.lua :call DeleteTrailing()
autocmd BufWrite *.py :call DeleteTrailing()
autocmd BufWrite *.coffee :call DeleteTrailing()
autocmd BufWrite *.java :call DeleteTrailing()

" Neomake

let g:neomake_javascript_enabled_makers = ['eslint']
let g:neomake_jsx_enabled_makers = ['eslint']
let g:neomake_echo_current_error=1
let g:neomake_verbose=0

let g:neomake_error_sign = {
    \ 'text': '×',
    \ 'texthl': 'ErrorMsg',
    \ }

let g:neomake_warning_sign = {
    \ 'text': '!',
    \ 'texthl': 'WarningMsg',
    \ }

let g:neomake_open_list = 0

let g:neomake_javascript_eslint_maker = {
    \ 'exe': './node_modules/eslint/bin/eslint.js',
    \ }


call neomake#configure#automake('nrwi', 500)
augroup SyntaxChecking
  autocmd BufWritePost,BufEnter *.js Neomake
  autocmd BufWritePost,BufEnter *.jsx Neomake
augroup end

" Neoformat
"
"
" let g:neoformat_javascript_prettier = {
" \ 'exe': './node_modules/.bin/prettier',
" \ 'args': ['--stdin', '--print-width 120', '--trailing-comma all', '--no-single-quote'],
" \ 'stdin': 1,
" \ }

let g:neoformat_javascript_prettier = {
 \ 'exe': './node_modules/.bin/prettier',
 \ 'args': ['--write', '--config $(./node_modules/.bin/prettier --find-config-path %:p)'],
 \ 'replace': 1
 \ }

let g:neoformat_enabled_javascript = ['prettier']

augroup fmt
  autocmd!
  autocmd BufWritePre *.js,*.jsx Neoformat! javascript
augroup end

" Wildignores
set wildignore +=*.svn
set wildignore +=*.class
set wildignore +=target/**
set wildignore +=.bundle
set wildignore +=*/node_modules/*
set wildignore +=tmp/**


" Delete trailing whitespaces
func! DeleteTrailing()
   exe "normal mz"
   %s/\s\+$//ge
   exe "normal `z"
endfunc
