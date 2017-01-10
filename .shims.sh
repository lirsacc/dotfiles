# From https://github.com/creationix/nvm/issues/539#issuecomment-110643090
# Creates a function which will source the given file on first call.
# Removed the check on file existence for virtualenvwrapper.sh, trust that
# I know what I am doing.

lazy_source () {
  eval "$1 () { echo 'Sourcing $2' && source $2 && $1 \$@ }"
}

lazy_source mkvirtualenv "virtualenvwrapper.sh"
lazy_source rmvirtualenv "virtualenvwrapper.sh"
lazy_source workon "virtualenvwrapper.sh"

lazy_source nvm "${NVM_DIR}/nvm.sh"
