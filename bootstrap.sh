#!/usr/bin/env bash

# Usage
# ==============================================================================

usage="$(basename "$0") [-hfls] -- Bootstraping dotfiles\n
  -h  help
  -f  force overwrite files in user's home directory
  -l  use local repo only and do not update from git
  -s  rsync only"

# Setup
# ==============================================================================

OPTIND=1

force=false
pull=true
sync_only=false

scripts="install"
directories=("projects")

while getopts "hfls?:" opt; do
  case "$opt" in
  h|\?)
    echo -e "$usage" && echo && exit 0
    ;;
  f)
    force=true
    ;;
  l)
    pull=false
    ;;
  s)
    sync_only=true
    ;;
  esac
done

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

[ "$(uname -s)" = "Darwin" ] && osx=true || osx=false

# Rsync the config files from git directory to home directory
function _rsync() {
  echo "rsync'ing files to your home directory..."
    rsync \
    --exclude ".git/" --exclude "./$scripts" --exclude ".DS_Store" \
    --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
    -av --no-perms . ~
}

# Install homebrew
function install_homebrew() {
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function cleanup () {
  unset _rsync install_homebrew force pull skip osx
  rm -rf "${HOME:?}/$scripts"
}

# Bootstrap dotfiles
# ==============================================================================

echo
echo "Running dotfiles bootstraping script"
echo "------------------------------------------------------------------------"
echo

# Update dotfiles from git repo
if $pull; then
  # shellcheck disable=SC2128
  cd "$(dirname "${BASH_SOURCE}")" || exit 1
  echo "Update from git"
  git pull origin master
  echo
fi

# Create necessary directories
for d in "${directories[@]}"; do
  mkdir -p "$HOME/$d"
done

if $force; then
    _rsync
else
    read -rp "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && _rsync || echo
fi

# Exit early
if $sync_only; then
  cleanup
  exit 0
fi

# Homebrew install
if [[ -z $(which brew) ]] && $osx; then
  if $force; then
    install_homebrew
  else
    read -rp "Do you want to install homebrew ? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && install_homebrew || echo
  fi
fi

if [[ ! -z $(which brew) ]] && $osx; then
  if $force; then
    source .brewfile
    source .caskfile
  else
    read -rp "Do you want to install homebrew recipes ? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && source .brewfile || echo
    read -rp "Do you want to install cask recipes ? (y/n) " -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && source .caskfile || echo
  fi
fi

for file in ./$scripts/*
do
  if [[ ! -f $file ]]; then
    continue
  fi
  filename=$(echo "$file" | cut -d / -f 3 | cut -d '.' -f 1)

  # Skip osx specific install files if uname is not Darwin
  [[ ! $osx ]] && [[ $file =~ osx ]] && continue

  if $force; then
    # shellcheck source=/dev/null
    . ./$file
  else
    read -rp "Do you want to apply the $filename install script ? (y/n) " -n 1
    # shellcheck source=/dev/null
    [[ $REPLY =~ ^[Yy]$ ]] && . ./$file
  fi
  echo
done

cleanup
