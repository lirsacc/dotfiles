#!/usr/bin/env bash

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle/

vim --noplugin -u ~/.vim/vundles.vim -N "+set hidden" "+syntax on" +BundleClean! +BundleInstall +qall