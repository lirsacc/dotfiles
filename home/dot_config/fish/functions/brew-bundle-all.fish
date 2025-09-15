function brew-bundle-all --description "Execute brew bundle commands over multiple Brewfiles in current directory"
    # Set the location to search for Brewfiles
    set brew_files_location (set -q BREW_BUNDLE_FILES_LOCATION; and echo $BREW_BUNDLE_FILES_LOCATION; or echo "$HOME/.config/homebrew")

    # All arguments are passed to brew bundle
    set brew_args $argv

    # Find all Brewfiles in the specified location
    set brewfiles $brew_files_location/Brewfile*
    set existing_files

    for file in $brewfiles
        if test -f $file
            set -a existing_files $file
        end
    end

    # Check if we found any files
    if test (count $existing_files) -eq 0
        echo "Error: No Brewfiles found in $brew_files_location"
        echo "Set BREW_BUNDLE_FILES_LOCATION environment variable to specify a different location"
        return 1
    end

    # Display what files we're processing
    echo "Processing Brewfiles from $brew_files_location:"
    for file in $existing_files
        echo "  "(basename $file)
    end
    echo

    # Concatenate all files and pipe to brew bundle
    cat $existing_files | brew bundle --file=- $brew_args
end
