# Empty the Trash on all mounted volumes and the main HDD
function empty-trash
    sudo rm -frv /Volumes/*/.Trashes
    sudo rm -frv ~/.Trash
    sudo rm -v /private/var/vm/sleepimage
    sudo rm -frv /private/var/log/asl/*.asl
    sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'
end
