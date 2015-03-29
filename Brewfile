#!/usr/bin/env bash

# Make sure we’re using the latest Homebrew
brew update

# Upgrade any already-installed formulae
brew upgrade

# Install GNU core utilities (those that come with OS X are outdated)
brew install coreutils
# Install some other useful utilities like `sponge`
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`
brew install gnu-sed --default-names
# Install Bash 4
brew install bash
brew install bash-completion

brew install htop

# Install wget with IRI support
brew install wget --enable-iri

# Install more recent versions of some OS X tools
brew install vim --override-system-vi
brew install homebrew/dupes/grep
brew install homebrew/dupes/screen
# brew install homebrew/php/php55 --with-gmp

# Install other useful binaries
brew install ack
brew install git
brew install imagemagick --with-webp
brew install node
mkdir -p ~/.nvm && brew install nvm
brew install pigz
brew install rename
brew install tree
brew install webkit2png
brew install zopfli
brew install ngrep
brew install hr
brew install ag
brew install ctags
brew install go

brew tap homebrew/completions
brew install vagrant-completion

# Python install
brew install python --framework

# DB Services
# brew install postgresql --with-python
# brew install mongodb
# brew install redis
# brew install rethinkdb

# Remove outdated versions from the cellar
cleanup
