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
