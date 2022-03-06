#!/usr/bin/env zsh

ZGEN_AUTOLOAD_COMPINIT=0

autoload -Uz compinit

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
    zgen prezto python
    # zgen prezto node
    zgen prezto git
    zgen prezto osx
    # zgen prezto homebrew

    # # prezto options
    zgen prezto editor key-bindings 'emacs'
    # zgen prezto editor dot-expansion 'yes'
    zgen prezto prompt theme 'smiley'

    zgen prezto 'git:alias' skip yes
    zgen prezto 'git:status:ignore' submodules all

    zgen save
fi


[[ -f "${HOME}/.aliases" ]] && source "${HOME}/.aliases"
[[ -f "${HOME}/.functions" ]] && source "${HOME}/.functions"
[[ -f "${HOME}/.exports" ]] && source "${HOME}/.exports"

[[ -f "${HOME}/.extra" ]] && source "${HOME}/.extra"
[[ -f "${HOME}/.local" ]] && source "${HOME}/.local"

eval "$(direnv hook zsh)"
. /opt/homebrew/opt/asdf/libexec/asdf.sh

unsetopt CORRECT

HISTDUP=erase           # Erase duplicates in the history file
setopt appendhistory    # Append history to the history file (no overwriting)
setopt sharehistory     # Share history across terminals
setopt incappendhistory # Immediately append to the history file, not just when a term is killed

bindkey '^U' backward-kill-line
