#!/usr/bin/env bash

echo
echo "Running Dotfiles Install Script"
echo

# Update dotfiles from git repo
cd "$(dirname "${BASH_SOURCE}")"
echo " * Update from git"
git pull origin master
echo

# Rsync the config files from git directory to home directory
function doIt() {
  echo " * Started copying files to your home directory..."
    rsync \
    --exclude ".git/" --exclude ".installs/" --exclude ".DS_Store" \
    --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
    -av --no-perms . ~
}

# Pass the -f or --force flag to force skip confirmation
if [ "$1" == "--force" -o "$1" == "-f" ]; then
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
  read -p " * Do you want to apply the $filename install script ? (y/n) " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    . ./$file
  fi
  echo
done

source ~/.bash_profile
