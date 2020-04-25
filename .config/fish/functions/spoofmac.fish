function spoof -d "Spoof your mac adress on en0"
    set -lx mac (openssl rand -hex 6 | sed 's/\(..\)/\1:/g; s/.$//')
    echo "Changing en0 MAC to $mac"
    sudo ifconfig en0 ether "$mac"
end
