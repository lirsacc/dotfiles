#!/usr/bin/env bash

set -eufo pipefail

# Brewfile hash: {{ include "~/.config/Brewfile" | sha256sum }}
# MacOS build version: {{ output "sw_vers" "--buildVersion" }}

export HOMEBREW_BAT=1
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BUILD_FROM_SOURCE=0
export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_ANALYTICS=1
export HOMEBREW_BUNDLE_FILE_GLOBAL="~/.config/Brewfile"
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE="1"
export HOMEBREW_BUNDLE_MAS_SKIP="1"

brew bundle --global install
brew update
brew upgrade
