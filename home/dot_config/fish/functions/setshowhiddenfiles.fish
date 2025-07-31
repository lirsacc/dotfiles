function setshowhiddenfiles
    defaults write com.apple.Finder AppleShowAllFiles -bool $argv[1]
    osascript -e 'tell application "Finder" to quit'
    sleep 0.25
    osascript -e 'tell application "Finder" to activate'
end
