#!/usr/bin/env bash
#
# Extracted from the oxc install.
# Set the computer name (as done via System Preferences → Sharing)

echo "Setting your computer name (as done via System Preferences & Sharing)"

if [[ -z "$1" ]]; then
  read -r -p "What would you like it to be (leave blank if don't want to set it) " COMPUTER_NAME
  if [ -z "$COMPUTER_NAME" ]; then
    echo "Name will not be changed."
    exit 0
  fi
else
  echo "You've selected the name /${1}/"
  COMPUTER_NAME="$1"
fi

sudo scutil --set ComputerName "$COMPUTER_NAME"
sudo scutil --set HostName "$COMPUTER_NAME"
sudo scutil --set LocalHostName "$COMPUTER_NAME"
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
