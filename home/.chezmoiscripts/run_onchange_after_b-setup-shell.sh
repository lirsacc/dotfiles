#!/usr/bin/env bash

set -eufo pipefail
set -x

# Sudo seems needed here as otherwise it won't allow
# setting a non builtin shell
sudo chsh -s /opt/homebrew/bin/fish
