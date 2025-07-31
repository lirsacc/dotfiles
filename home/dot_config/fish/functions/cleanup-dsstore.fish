function cleanup-dsstore --wraps="find . -type f -name '*.DS_Store' -ls -delete" --description "alias cleanup-dsstore=find . -type f -name '*.DS_Store' -ls -delete"
  find . -type f -name '*.DS_Store' -ls -delete $argv
        
end
