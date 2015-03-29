#!/usr/bin/env bash

# Define help text
usage="$(basename "$0") [-h] [-f l] -- Bootstraping dotfiles\n\n
  -h  help\n
  -f  force overwrite files in user's home directory\n
  -l  use local repo and do not update from git"

# Read cli args and set system specific flags
OPTIND=1

force=false
update=true

while getopts "h?fl:" opt; do
  case "$opt" in
  h|\?)
    echo -e $usage && echo && exit 0
    ;;
  f)
    force=true
    ;;
  l)
    update=false
    ;;
  esac
done

echo
echo "Running Dotfiles Install Script"
echo "------------------------------------------------------------------------"
echo

shift $((OPTIND-1))
[ "$1" = "--" ] && shift

UNAME=$(uname)
[[ "$UNAME" == "Darwin" ]] && osx=true || osx=false

# Update dotfiles from git repo
if [ $update == true ]; then
  cd "$(dirname "${BASH_SOURCE}")"
  echo " * Update from git"
  git pull origin master
  echo
fi

# Rsync the config files from git directory to home directory
function doIt() {
  echo " * Rsyncing files to your home directory..."
    rsync \
    --exclude ".git/" --exclude ".installs/" --exclude ".DS_Store" \
    --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
    -av --no-perms . ~
}

# Pass the -f or --force flag to force skip confirmation
if [ $force == true ]; then
    doIt
else
    read -p " * This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    else
      echo
    fi
fi

unset doIt

for file in .installs/*
do
  filename=`echo $file | cut -d '/' -f 2`

  # Skip osx specific install files if uname is not Darwin
  if [[ $osx == false ]] && [[ $filename =~ 'osx' ]]; then
    continue
  fi
  
  read -p " * Do you want to apply the $filename install script ? (y/n) " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    . ./$file
  fi
  echo
done

source ~/.bash_profile
