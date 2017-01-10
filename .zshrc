#!/usr/bin/env zsh

fpath=(~/.zfuncs "${fpath[@]}")
typeset -U fpath

autoload -Uz ~/.zfuncs/*(:t)
autoload -Uz compinit
# compinit

bindkey \^U backward-kill-line

source "${HOME}/.zgen/zgen.zsh"

# check if there's no init script
if ! zgen saved; then
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

source "${HOME}/.aliases"
source "${HOME}/.functions"
source "${HOME}/.exports"
source "${HOME}/.extra"

source "${HOME}/.aws_helpers.sh"
source "${HOME}/.shims.sh"

# source "${HOME}/.brew.sh"
# source "${HOME}/.colors.sh"

unsetopt CORRECT

HISTDUP=erase               #Erase duplicates in the history file
setopt    appendhistory     #Append history to the history file (no overwriting)
setopt    sharehistory      #Share history across terminals
setopt    incappendhistory  #Immediately append to the history file, not just when a term is killed
