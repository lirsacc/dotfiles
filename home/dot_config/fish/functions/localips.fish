function localips
    networksetup -listallhardwareports |
    sed -r "s/Hardware Port: (.*)/\x1B\[35m\1\x1B\[m/g" |
    sed -r "s/(Device: .*)/  \1/g" |
    sed -r "s/Ethernet Address:/ /g" |
    sed -r "s/(VLAN Configurations)|==*//g" |
    sed -r '/^$/N;/^\n$/D'
end
