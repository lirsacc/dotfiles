" ========================================
" Vim plugin configuration
" ========================================
"
" This file contains the list of plugin installed using vundle plugin manager.
" Once you've updated the list of plugin, you can run vundle update by issuing
" the command :BundleInstall from within vim or directly invoking it from the
" command line with the following syntax:
" vim --noplugin -u ./vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall
" Filetype off is required by vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle (required)
Bundle 'gmarik/vundle'

" All your bundles here

Bundle 'flazz/vim-colorschemes'
Bundle 'airblade/vim-gitgutter'
Bundle 'tpope/vim-commentary'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-fugitive'
Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle "myusuf3/numbers.vim"
Bundle 'godlygeek/tabular'
Bundle 'tpope/vim-surround'
Bundle 'Shougo/neocomplcache'

" Syntaxes fix

Bundle 'leshill/vim-json'
Bundle 'pangloss/vim-javascript'
Bundle 'indenthtml.vim'
Bundle 'tpope/vim-markdown'
Bundle 'groenewege/vim-less'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/ctrlp.vim'

" Bundle 'JulesWang/css.vim' " only necessary if your Vim version < 7.4
Bundle 'cakebaker/scss-syntax.vim'

"Filetype plugin indent on is required by vundle
filetype plugin indent on
