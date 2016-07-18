#!/usr/bin/env zsh

source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
  echo "Zgen init ----------------------------------------------------"

  # prezto and modules
  zgen prezto

  zgen prezto environment
  zgen prezto terminal
  zgen prezto editor
  zgen prezto history
  zgen prezto directory
  # zgen prezto spectrum
  # zgen prezto utility
  zgen prezto completion
  zgen prezto prompt
  zgen prezto history-substring-search
  # zgen prezto command-not-found
  zgen prezto syntax-highlighting
  # zgen prezto python
  # zgen prezto node
  zgen prezto git
  # zgen prezto osx
  # zgen prezto homebrew

  # # prezto options
  zgen prezto editor key-bindings 'emacs'
  # zgen prezto editor dot-expansion 'yes'
  zgen prezto prompt theme 'smiley'

  zgen save
fi

source ~/.aliases
source ~/.exports
source ~/.extra
source ~/.functions
source ~/.shims.sh
source ~/.aws_helpers.sh
# source ~/.brew.sh
# source ~/.colors.sh

unsetopt CORRECT

HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed

fpath=(~/.zfuncs "${fpath[@]}")
typeset -U fpath
autoload -Uz ~/.zfuncs/*(:t)

autoload -Uz compinit
compinit

bindkey \^U backward-kill-line
