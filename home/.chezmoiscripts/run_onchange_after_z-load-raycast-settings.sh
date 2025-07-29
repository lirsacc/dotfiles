#!/usr/bin/env bash

set -eufo pipefail

# hash: {{ include "~/.config/raycast/Raycast.rayconfig" | sha256sum }}
open -a Raycast ~/.config/raycast/Raycast.rayconfig
