# From https://github.com/creationix/nvm/issues/539#issuecomment-110643090
# Creates a function which will source the given file on first call.
# Keep your shell startup fast by not doing stuff at the cost of lossing
# completion for certain commands and missing commands in $PATH.

lazy_source () {
  eval "$1 () { unset -f $1; $2; $1 \$@ }"
}

function source_nvm() {
  unset -f nvm node npm > /dev/null 2>&1
  # shellcheck disable=SC1090
  [ -s "${NVM_DIR}"/nvm.sh ] \
    && . "${NVM_DIR}/nvm.sh" \
    && [ -s .nvmrc ] && nvm use
}

lazy_source nvm "source_nvm"
lazy_source node "source_nvm"
lazy_source npm "source_nvm"
