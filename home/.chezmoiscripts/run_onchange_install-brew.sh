#!/usr/bin/env bash

set -eufo pipefail

# Brewfile hash: {{ include ".config/Brewfile" | sha256sum }}
# MacOS build version: {{ output "sw_vers" "--buildVersion" }}
brew bundle --global install
brew update
brew upgrade
