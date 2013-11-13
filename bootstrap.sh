#!/usr/bin/env bash

echo
echo "DOTFILES INSTALL SCRIPT"
echo "-----------------------"
echo

cd "$(dirname "${BASH_SOURCE}")"
echo " => Update from git"
git pull origin master
echo

function doIt() {
  echo "=> Started copying files to your home directory"
	rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
		--exclude "README.md" --exclude "LICENSE-MIT.txt" -av --no-perms . ~
	source ~/.bash_profile
  echo "=> Finished with sourced bash_profile"
}

if [ "$1" == "--force" -o "$1" == "-f" ]; then
	doIt
else
	read -p "=> This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1
	echo
	if [[ $REPLY =~ ^[Yy]$ ]]; then
		doIt
	fi
fi
unset doIt
echo

for file in .installs/*
do
  filename=`echo $file | cut -d '/' -f 2`
  read -p "=> Do you want to apply the $filename install script ? (y/n) " -n 1
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    . ./$file
  fi
  echo
done
