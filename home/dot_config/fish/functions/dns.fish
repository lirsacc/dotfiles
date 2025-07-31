function dns --description 'Compact DNS results'
    if test (count $argv) = 0
        echo "Missing required argument: hostname"
        return 1
    end

    dig +nocmd (domain $argv[1]) any +multiline +noall +answer
end
