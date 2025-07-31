function cleanup-asl-logs --wraps='sudo rm -rfv /private/var/log/asl/*.asl' --description 'alias cleanup-asl-logs=sudo rm -rfv /private/var/log/asl/*.asl'
  sudo rm -rfv /private/var/log/asl/*.asl $argv
        
end
