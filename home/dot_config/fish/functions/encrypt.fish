function encrypt --wraps='openssl enc -aes-256-cbc -salt -a' --description 'alias encrypt openssl enc -aes-256-cbc -salt -a'
  openssl enc -aes-256-cbc -salt -a $argv
        
end
