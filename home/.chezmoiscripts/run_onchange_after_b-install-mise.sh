#!/usr/bin/env bash

set -eufo pipefail

# hash: {{ include "~/.config/mise/mise.toml" | sha256sum }}
mise install
