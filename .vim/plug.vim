" ========================================
" Vim plugin configuration (vim-plug)
" ========================================

call plug#begin()

Plug 'editorconfig/editorconfig-vim'
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree', { 'on': ['NERDTreeToggle', 'NERDTreeFind'] }
Plug 'myusuf3/numbers.vim'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-surround'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'majutsushi/tagbar'
Plug 'jlanzarotta/bufexplorer'
Plug 'mattn/emmet-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'mattreduce/vim-mix'
Plug 'leshill/vim-json'
Plug 'jelera/vim-javascript-syntax'
Plug 'pangloss/vim-javascript'
Plug 'indenthtml.vim'
Plug 'tpope/vim-markdown'
Plug 'groenewege/vim-less'
Plug 'Valloric/YouCompleteMe', { 'do': './install.py --clang-completer --tern-completer --gocode-completer' }
Plug 'kchmck/vim-coffee-script'
Plug 'fatih/vim-go'
Plug 'cakebaker/scss-syntax.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'mxw/vim-jsx'
Plug 'itchyny/lightline.vim'

" Add plugins to &runtimepath
call plug#end()
filetype plugin indent on

