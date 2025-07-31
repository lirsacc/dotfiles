function flush-dns --wraps='dscacheutil -flushcache && killall -HUP mDNSResponder' --description 'alias flush-dns=dscacheutil -flushcache && killall -HUP mDNSResponder'
  dscacheutil -flushcache && killall -HUP mDNSResponder $argv
        
end
