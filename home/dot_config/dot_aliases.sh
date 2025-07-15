#!/usr/bin/env bash

# -----------------------------------------------------------------------------
# Shell aliases, should be compatible with bash, zsh and fish
# -----------------------------------------------------------------------------

# Reload the shell (i.e. invoke as a login shell)
alias reload='exec $SHELL -l'

# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

# Git
alias g="git"
alias gst="g s"
alias gl="g l"
alias gd="g d"

alias ls="ls --color=auto" # Always use color output for `ls`
alias l="ls -lFh --color=auto" # List all files colorized in long format
alias ll="ls -laFh --color=auto" # List all files colorized in long format, including dot files
alias lsd='ls -lFh --color=auto | grep "^d"' # List only directories

# Get week number
alias week='date +%V'

# Mac OS related things
# -----------------------------------------------------------------------------

# Flush Directory Service cache
alias flush-dns="dscacheutil -flushcache && killall -HUP mDNSResponder"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# OS X has no `md5sum`, so use `md5` as a fallback
command -v md5sum > /dev/null || alias md5sum="md5"

# OS X has no `sha1sum`, so use `shasum` as a fallback
command -v sha1sum > /dev/null || alias sha1sum="shasum"

# Canonical hex dump; some systems have this symlinked
command -v hd > /dev/null || alias hd="hexdump -C"

# Recursively delete `.DS_Store` files
alias cleanup-dsstore="find . -type f -name '*.DS_Store' -ls -delete"

# Clear Apple’s System Logs to improve shell startup speed
alias cleanup-asl-logs="sudo rm -rfv /private/var/log/asl/*.asl"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff="sudo mdutil -a -i off"
# Enable Spotlight
alias spoton="sudo mdutil -a -i on"

# PlistBuddy alias, because sometimes `defaults` just doesn’t cut it
alias plistbuddy="/usr/libexec/PlistBuddy"

alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume output volume 100'"

# Misc.
# -----------------------------------------------------------------------------

# ROT13-encode text. Works for decoding, too! ;)
alias rot13='tr a-zA-Z n-za-mN-ZA-M'

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

alias encrypt "openssl enc -aes-256-cbc -salt -a"
alias decrypt "openssl enc -aes-256-cbc -d -a"

# IP addresses
alias ip "curl ipinfo.io/ip 2>/dev/null|| echo -n ''"
alias ip4 "curl -4 ipinfo.io/ip 2>/dev/null|| echo -n ''"
alias ip6 "curl -6 ipinfo.io/ip 2>/dev/null|| echo -n ''"
