# Useful shortcuts and helpers.

# Show/hide hidden files in Finder
function setshowhiddenfiles
    defaults write com.apple.Finder AppleShowAllFiles -bool $argv[1]
    osascript -e 'tell application "Finder" to quit'
    sleep 0.25
    osascript -e 'tell application "Finder" to activate'
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

function spoofmac -d "Spoof your mac adress on en0"
    set -lx mac (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "Changing en0 MAC to $mac"
    sudo ifconfig en0 ether "$mac"
end

function dns -d "Compact DNS results"
    if test (count $argv) = 0
        echo "Missing required argument: hostname"
        return 1
    end

    dig +nocmd (domain $argv[1]) any +multiline +noall +answer
end

function domain
    set -l parts (string split / -- $argv[1])
    set -l domain $parts[1]

    if test -z "$domain"
        set -l domain $argv[1]
    end

    echo (string replace www. '' $domain)
end

function abspath -d 'Calculates the absolute path for the given path'
    set -l cwd ''
    set -l curr (pwd)
    cd $argv[1]; and set cwd (pwd); and cd $curr
    echo $cwd
end
