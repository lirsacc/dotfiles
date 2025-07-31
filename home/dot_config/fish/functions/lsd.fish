function lsd --wraps='ls -lFh --color=auto | grep "^d"' --description 'alias lsd=ls -lFh --color=auto | grep "^d"'
  ls -lFh --color=auto | grep "^d" $argv
        
end
