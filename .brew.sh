#!/usr/bin/env bash

# Useful brew shortcuts taken from https://github.com/thoughtbot/laptop

brew-install-or-upgrade() {
  if brew-is-installed "$1"; then
    if brew-is-upgradable "$1"; then
      brew upgrade "$@"
    fi
  else
    brew install "$@"
  fi
}

brew-is-installed() {
  local name
  name="$(brew-expand-alias "$1")"
  res=$(brew ls --versions "$name")
  if [[ -z "$res" ]]; then
    return 1
  else
    return 0
  fi
}

brew-is-upgradable() {
  local name
  name="$(brew-expand-alias "$1")"
  ! brew outdated --quiet "$name" >/dev/null
}

brew-tap() {
  brew tap "$1" --repair 2> /dev/null
}

brew-expand-alias() {
  brew info "$1" 2>/dev/null | head -1 | awk '{gsub(/.*\//, ""); gsub(/:/, ""); print $1}'
}
