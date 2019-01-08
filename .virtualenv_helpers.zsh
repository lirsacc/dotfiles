#!/usr/bin/env zsh
# Poor man's virtualenvwrapper for Python 2/3 on Mac OS X + ZSH which only does
# what I use from it...
# Assumes python has been installed via brew and global `python`` points to
# Python 3 while Python 2 is behind `python2``

# - create virtualenv for the current project directory and alias them to `.venv`
# - activate the virtualenv `.venv` points at
# - destroy virtualenvs by name
# - activate virtualenvs by name
# - all virtualanvs are assumed to be in ${WORKON_HOME}

# Activate virtualenv aliased as `.venv` in current directory`
function venv() {
  if [ -d "./.venv" ]; then
    # shellcheck disable=1090
    source "$(pwd)/.venv/bin/activate"
  else
    echo 'Missing .venv alias'
    return 1
  fi
}

# Create a virtualenv
function mkvirtualenv() {

  local name
  name=$(basename "$(pwd)")
  local version
  version=3
  local alias
  alias=true
  local force
  force=false

  local param

  while [ "${1}" != "" ]; do
    param=${1}
    case "${param}" in
      --help | -h)
        echo "Create a virtualenv"
        echo ""
        echo "Usage:"
        echo -e "\t${0} [--help] [--name STRING] [--alias] [--version INT] [--force]"
        echo ""
        echo "Optional arguments:"
        echo ""
        echo -e "\t-h, --help\tShow this text and exit"
        echo -e "\t-n, --name\tName for the virtualenv, defaults to current directory name (${name})"
        echo -e "\t--no-alias\tDo not create a local .venv alias to the virtualenv directory"
        echo -e "\t-v, --version\tShould be 2 or 3 to decide which pyton version is used, defaults to ${version}"
        echo -e "\t-f, --force\tOverride any pre-existing virtualenv"
        echo
        return
        ;;
      --no-alias)
        alias=false
        shift 1
        ;;
      --force | -f)
        force=true
        shift 1
        ;;
      --name | -n)
        name="${2:-${name}}"
        shift 2
        ;;
      --version | -v)
        version="${2:-${version}}"
        shift 2;;
      *)
        echo "ERROR: unknown parameter \"$param\""
        return 1
        ;;
    esac
  done

  if [ "$force" = false ] && [ -d "${WORKON_HOME:?}/${name}" ]; then
    echo "Virtualenv ${name} already exists in ${WORKON_HOME:?}"
    return 1
  fi

  if [ "$version" -eq "3" ]; then
    python3 -m venv --clear --copies "${WORKON_HOME:?}/${name}"
  elif [ "$version" -eq "2" ]; then
    python2 -m virtualenv --python "$(command -v python2)" --clear --always-copy "${WORKON_HOME:?}/${name}"
  else
    echo "Unknown python version ${version}"
    return 1
  fi

  if [ "$alias" = true ]; then
    ln -s "${WORKON_HOME:?}/${name}" .venv
  fi

  workon "${name}"
}

# Destroy a virtualenv by name with ZSH completion
function rmvirtualenv() {
  rm -rf "${WORKON_HOME:?}/${1?Missing first argument}"
}

# Activate virtualenv by name with ZSH completion
function workon() {
  # shellcheck disable=1090
  source "${WORKON_HOME:?}/${1?Missing first argument}/bin/activate"
}

function _venvs() {
  _alternative "dirs:virtualenvs:($(find "${WORKON_HOME:?}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \;))"
}

compdef _venvs workon rmvirtualenv
