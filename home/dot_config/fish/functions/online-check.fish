function online-check
    set -lx offline (dig 8.8.8.8 +time=1 +short google.com A | grep -c "no servers could be reached")
    if test $offline = "0"
        return 0
    else
        return 1
    end
end
