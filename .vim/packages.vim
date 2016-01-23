" ========================================
" Vim plugin configuration
" ========================================
"
" Install with:
" vim --noplugin -u ./vim/packages.vim -N "+set hidden" "+syntax on" +PluginClean! +PluginInstall +qall
"

set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'editorconfig/editorconfig-vim'
Plugin 'flazz/vim-colorschemes'
" Plugin 'davidhalter/jedi-vim'
Plugin 'airblade/vim-gitgutter'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/nerdtree'
Plugin 'myusuf3/numbers.vim'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-surround'
Plugin 'kien/ctrlp.vim'
Plugin 'majutsushi/tagbar'
Plugin 'jlanzarotta/bufexplorer'
Plugin 'Shougo/neocomplete.vim'
Plugin 'mattn/emmet-vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'elixir-lang/vim-elixir'

" Syntax modes
Plugin 'leshill/vim-json'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'pangloss/vim-javascript'
Plugin 'indenthtml.vim'
Plugin 'tpope/vim-markdown'
Plugin 'groenewege/vim-less'
Plugin 'kchmck/vim-coffee-script'
Plugin 'fatih/vim-go'
Plugin 'cakebaker/scss-syntax.vim'

call vundle#end()
filetype plugin indent on

" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
