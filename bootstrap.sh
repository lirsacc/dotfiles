#!/usr/bin/env bash

echo
echo "DOTFILES INSTALL SCRIPT"
echo "======================="
echo

# Update dotfiles from git repo
cd "$(dirname "${BASH_SOURCE}")"
echo " => Update from git"
git pull origin master
git submodule update --init
echo

# Rsync the config files from git directory to home directory
function doIt() {
  echo "=> Started copying files to your home directory"
    rsync \
    --exclude ".git/" --exclude ".installs/" --exclude ".DS_Store" \
    --exclude "bootstrap.sh" --exclude "README.md" --exclude "LICENSE-MIT.txt" \
    --exclude "iterm2" \
    -av --no-perms . ~
  echo "=> Finished with sourced bash_profile"
}

# Pass the -f or --force flag to force skip confirmation
if [ "$1" == "--force" -o "$1" == "-f" ]; then
    doIt
else
    read -p "=> This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        doIt
    fi
fi
unset doIt

# Homebrew
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

read -p "=> Install homebrew formulas (Brewfile) ? (y/n) " -n 1
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    source Brewfile
    read -p "=> Install casks (Caskfile) ? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
	    source Caskfile
	    brew cask alfred link
	fi
fi

# Install NVM latest
if test ! $(which nvm); then
    echo "Installing nvm..."
    current=$(pwd)
    git clone https://github.com/creationix/nvm.git ~/.nvm
    cd ~/.nvm
    git checkout `git describe --abbrev=0 --tags`
    cd $current
    unset current
fi

for file in .installs/*
do
  filename=`echo $file | cut -d '/' -f 2`
  read -p "=> Do you want to apply the $filename install script ? (y/n) " -n 1
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    . ./$file
  fi
  echo
done

echo "=> Removing install scripts"
source ~/.bash_profile
rm -rf ~/.installs
