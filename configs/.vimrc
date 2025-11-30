" --- Minimal, Native .vimrc ---
" Sets up basic features and native color. No external plugins are used.

set nocompatible              " Be iMproved

" 1. Enable Syntax Highlighting and 256 Colors
syntax on
set background=dark           " Assume a dark terminal background
set t_Co=256                  " Enable 256 colors

" 2. Basic Functionality and Aesthetics
set encoding=utf-8            " Use UTF-8 encoding
set number                    " Show line numbers
set autoindent                " Auto-indent
set smarttab                  " Smart tabs

" Optional: Use a simple native colorscheme if you want more than black/white
" colorscheme desert
" colorscheme Nord
