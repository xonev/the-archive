" Required for vundle
filetype off

" Active bundles
Bundle 'tpope/vim-fugitive'
Bundle 'ervandew/supertab'
Bundle 'kien/ctrlp.vim'
Bundle 'mileszs/ack.vim'
Bundle 'airblade/vim-gitgutter'
Bundle 'kchmck/vim-coffee-script'
"Bundle 'paredit.vim'
Bundle 'tpope/vim-sexp-mappings-for-regular-people'
Bundle 'guns/vim-sexp'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-fireplace'
Bundle 'guns/vim-clojure-static'
Bundle 'scratch.vim'
Bundle 'jtratner/vim-flavored-markdown'
Bundle 'jeffkreeftmeijer/vim-numbertoggle'

" Copy and cut to system clipboard
vmap <C-x> :!pbcopy<CR>
vmap <C-c> :w !pbcopy<CR><CR>

" Mouse support
set mouse=a

" Automatically remove whitespace
autocmd BufWritePre * :%s/\s\+$//e

" Auto indent when inserting a new line
set autoindent

" Tab configuration
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab
filetype plugin indent on

" Backspace configuration
set backspace=indent,eol,start

" Auto indent
set ai

" Smart indent
set si

" Wrap lines
set wrap

" Wild Menus
set wildmenu

" Syntax highlighting
"set re=1 " set regular expressions engine to old version because ruby highlighting was slow (http://stackoverflow.com/questions/16902317/vim-slow-with-ruby-syntax-highlighting)
let ruby_no_expensive = 1
syntax on


" Split to the right, below
set splitbelow
set splitright

" Ctrl P mapping
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" Infinite search range for Ctrl P
let g:ctrlp_max_files = 0

" Custom ctrlp ignores
let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git\|target'

" Change cursor to a line when in insert mode and a block when in command mode
"if exists('$TMUX')
"  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
"  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
"else
"  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
"  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
"endif

" Highlight current line
"highlight CursorLine ctermbg=238
set cursorline

" Always show current filename
set laststatus=2

" When vimrc is edited, reload it
autocmd! bufwritepost vimrc source ~/.vim_runtime/vimrc

" Lines to the cursors - when moving vertical..
set so=7

" Incremental search and highlighting
set incsearch
set hlsearch

" Sane colors for autocomplete
:highlight Pmenu ctermbg=238 gui=bold

" VimClojure settings
let vimclojure#FuzzyIndent = 1

" Make <Leader> ,
let mapleader = ","

" Vim-flavored-markdown settings
augroup markdown
    au!
    au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END
