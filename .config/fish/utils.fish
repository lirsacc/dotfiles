# Useful shortcuts and helpers.
#
# This file uses either aliases or short functions as they are conceptually the
# same in fish shell.
#
# Longer function should go in ~/config/fish/functions or ~/bin.

alias grep 'grep --color=auto '

alias ls "ls --color=auto"
alias l "ls -lFh --color=auto" # List all files colorized in long format
alias ll "ls -laFh --color=auto" # List all files colorized in long format, including dot files
alias lsd 'ls -lFh --color=auto | grep "^d"' # List only directories

function create
    if test ! -f "$argv[1]"
        install -Dv /dev/null "$argv[1]"
    end
end

# Get week number
alias week 'date +%V'

# Flush Directory Service cache
alias flush-dns "dscacheutil -flushcache && killall -HUP mDNSResponder &> /dev/null || true"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup "/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# View HTTP traffic
alias httpdump "sudo tcpdump -i en1 -n -s 0 -w - | grep -a -o -E \"Host\: .*|GET \/.*\""

# Recursively delete `.DS_Store` files
alias cleanup-dsstore "find . -type f -name '*.DS_Store' -ls -delete"

# Clear Apple’s System Logs to improve shell startup speed
alias cleanup-asl-logs "sudo rm -rfv /private/var/log/asl/*.asl"

# Show/hide hidden files in Finder
function setshowhiddenfiles
    defaults write com.apple.Finder AppleShowAllFiles -bool $argv[1]
    osascript -e 'tell application "Finder" to quit'
    sleep 0.25
    osascript -e 'tell application "Finder" to activate'
end

alias show "setshowhiddenfiles true"
alias hide "setshowhiddenfiles false"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop "defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop "defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# URL-encode strings
alias urlencode 'python -c "import sys, urllib.parse; sys.stdout.write(urllib.parse.quote(sys.stdin.read(), safe=\'\'));"'
alias urldecode 'python -c "import sys, urllib.parse; sys.stdout.write(urllib.parse.unquote(sys.stdin.read()));"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf '/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Disable Spotlight
alias spotoff "sudo mdutil -a -i off"
# Enable Spotlight
alias spoton "sudo mdutil -a -i on"

# Git
alias g "git"
alias gst "g s"
alias gl "g l"
alias gd "g d"
alias grb "g rb"

alias cask "brew cask"

# Docker
alias remove-docker-orphans 'docker rmi -f (docker images -f dangling=true -q)'

alias afk "/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"

alias stfu "osascript -e 'set volume output muted true'"
alias pumpitup "osascript -e 'set volume output volume 100'"

function remove-known-host
    sed -i "/$argv[1]/d" "$HOME/.ssh/known_hosts"
end

# Stolen and adapted (removed cron job, use as a command) from:
# https://github.com/nicksp/dotfiles/
function online-check
    set -lx offline (dig 8.8.8.8 +time=1 +short google.com A | grep -c "no servers could be reached")
    if test $offline = "0"
        return 0
    else
        return 1
    end
end

# IP addresses
alias ip 'dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed s/\"//g'
alias ip4 'dig -4 TXT +short o-o.myaddr.l.google.com @ns1.google.com | sed s/\"//g'

function localips
    networksetup -listallhardwareports |
    sed -r "s/Hardware Port: (.*)/\x1B\[35m\1\x1B\[m/g" |
    sed -r "s/(Device: .*)/  \1/g" |
    sed -r "s/Ethernet Address:/ /g" |
    sed -r "s/(VLAN Configurations)|==*//g" |
    sed -r '/^$/N;/^\n$/D'
end

function publicips
    set -lx blue '\x1B\e[34m'
    set -lx green '\x1B\e[32m'
    set -lx reset '\x1B\e[0m'

    set -lx externalip (ip)
    set -lx externalip4 (ip4)
    set -lx internalips (ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d\  -f2)

    echo
    echo -e $blue"External IP"$reset
    echo "  $externalip"
    if test $externalip != $externalip4
        echo "  $externalip4"
    end
    echo
    echo -e $green"Internal IP(s)"$reset
    for x in $internalips
        echo "  $x"
    end
    echo
end

function currentips
    publicips
    localips
end

# cp with progress
alias cp-p "rsync -WavP --human-readable --progress"

function randomchars -d "Generate a random string"
    dd if=/dev/urandom count=1 2>/dev/null |
    uuencode -m - |
    sed -ne 2p |
    cut -c-"$argv[1]"
end

function randomcharssafe -d "Generate a random alphanumeric string"
    cat /dev/urandom |
    tr -dc 'a-zA-Z0-9' |
    fold -w "$argv[1]" |
    head -n 1
end

function randombytes -d "Generate a stream of random bytes"
    dd if=/dev/urandom bs=(set -l x $argv[2] or "1M"; echo $x) count=$argv[1] 2>/dev/null | cat
end

alias encrypt "openssl enc -aes-256-cbc -salt -a"
alias decrypt "openssl enc -aes-256-cbc -d -a"

if hash git &>/dev/null
    alias diff 'git diff --no-index --color-words'
end
