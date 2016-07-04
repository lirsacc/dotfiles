function mkvirtualenv() {
  # shellcheck disable=1091
  source virtualenvwrapper.sh
  mkvirtualenv "$@"
}

function rmvirtualenv() {
  # shellcheck disable=1091
  source virtualenvwrapper.sh
  rmvirtualenv "$@"
}

function workon() {
  # shellcheck disable=1091
  source virtualenvwrapper.sh
  workon "$@"
}
