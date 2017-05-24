# From https://github.com/creationix/nvm/issues/539#issuecomment-110643090
# Creates a function which will source the given file on first call.
# Removed the check on file existence for virtualenvwrapper.sh, trust that
# I know what I am doing.

lazy_source () {
  eval "$1 () { unset -f $1; $2; $1 \$@ }"
}

lazy_source mkvirtualenv "source virtualenvwrapper.sh"
lazy_source rmvirtualenv "source virtualenvwrapper.sh"
lazy_source workon "source virtualenvwrapper.sh"

function source_nvm() {
  unset -f nvm node npm > /dev/null 2>&1
  # shellcheck disable=SC1090
  [ -s "${NVM_DIR}"/nvm.sh ] && . "${NVM_DIR}/nvm.sh"
}

lazy_source nvm "source_nvm"
lazy_source node "source_nvm"
lazy_source npm "source_nvm"
