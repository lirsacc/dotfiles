function domain
    set -l parts (string split / -- $argv[1])
    set -l domain $parts[1]

    if test -z "$domain"
        set -l domain $argv[1]
    end

    echo (string replace www. '' $domain)
end
