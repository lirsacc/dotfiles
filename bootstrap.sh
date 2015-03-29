#!/usr/bin/env bash

# Usage
# ==============================================================================

usage="$(basename "$0") [-hfls] -- Bootstraping dotfiles\n\n
  -h  help\n
  -f  force overwrite files in user's home directory\n
  -s  skip instal files (run them manually afterwards)\n
  -l  use local repo and do not update from git"

# Setup
# ==============================================================================

OPTIND=1

force=false
pull=true
skip=false
scripts='./scripts'

while getopts "hfls?:" opt; do
  case "$opt" in
  h|\?)
    echo -e $usage && echo && exit 0
    ;;
  f)
    force=true
    ;;
  l)
    pull=false
    ;;
  s)
    skip=true
    ;;
  esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

[ "$(uname -s)" = "Darwin" ] && osx=true || osx=false

# Rsync the config files from git directory to home directory
function _rsync() {
  echo " * rsync'ing files to your home directory..."
    rsync \
    --exclude ".git/" --exclude "scripts/" --exclude ".DS_Store" \
    --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
    -av --no-perms . ~
}

# Install homebrew
function _homebrew() {
  echo " * Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

# Bootstrap dotfiles
# ==============================================================================

echo
echo "Running dotfiles bootstraping script"
echo "------------------------------------------------------------------------"
echo

# Update dotfiles from git repo
if $pull; then
  cd "$(dirname "${BASH_SOURCE}")"
  echo " * Update from git"
  git pull origin master
  echo
fi

if $force; then
    _rsync
else
    read -p " * This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && _rsync || echo
fi

if [[ $(which brew) ]] && $osx; then
  if $force; then
    _homebrew
  else
    read -p " * Do you want to install homebrew ? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && _homebrew || echo
  fi
fi

if ! $skip; then
  for file in $scripts/*
  do
    filename=`echo $file | cut -d '/' -f 2`

    # Skip osx specific install files if uname is not Darwin
    [[ ! $osx ]] && [[ $filename =~ 'osx' ]] && continue

    if $force; then
      . ./$file
    else
      read -p " * Do you want to apply the $filename install script ? (y/n) " -n 1
      [[ $REPLY =~ ^[Yy]$ ]] && . ./$file
    fi
    echo
  done
fi

unset _rsync _homebrew force pull skip osx

source ~/.bash_profile
