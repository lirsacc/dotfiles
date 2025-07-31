function decrypt --wraps='openssl enc -aes-256-cbc -d -a' --description 'alias decrypt openssl enc -aes-256-cbc -d -a'
  openssl enc -aes-256-cbc -d -a $argv
        
end
