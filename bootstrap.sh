#!/usr/bin/env bash

# Uncomment for debug information
# set -x

# Safer bash script
set -euo pipefail

usage="
                                           .
Your friendly dotfiles bootstraper bot  ~(0_0)~

$(basename "$0") [options]

Options and arguments:

  -h, --help          Display this help text
  -d, --dry-run       Perform a dry run of the sync step
  -f, --force         Force overwrite files in target directory
  -l, --local         Use local repo only and do not update from git
  -s, --no-install    Sync only and doesn't run the install scripts

  --target            Use this location instead of \$HOME ($HOME), must be a directory
  --install           Look for install scripts there instead of $(pwd)/install
  --branch            Git branch to update from
  "

if ! [[ "$OSTYPE" =~ darwin* ]]; then
  echo "This is meant to be run on macOS only"
  exit
fi

# Parameters
# ------------------------------------------------------------------------------

scripts="${INSTALL_SCRIPTS:-"$(pwd)/install"}"
target="${HOME}"
directories=("projects")
branch="master"

rsync_exclude=(
  ".git/"
  "install"
  "${scripts}"
  ".DS_Store"
  "bootstrap.sh"
  "README.md"
  "LICENSE-MIT.txt"
  ".gitkeep"
  "_diff.sh"
  "_rename-computer.sh"
)

# Read the options
# ------------------------------------------------------------------------------

OPTIND=1

force=false
pull=true
sync_only=false
dry_run=false

optspec=":hflsdc-:"
OPTERR=0

while getopts "${optspec}" opt; do
  case "${opt}" in
    h)
      echo -e "$usage" && echo && exit 0
      ;;
    -)
      case ${OPTARG} in
        help)
          echo -e "$usage" && echo && exit 0
          ;;
        force)
          force=true
          ;;
        local)
          pull=false
          ;;
        no-install)
          sync_only=true
          ;;
        dry-run)
          dry_run=true
          ;;
        target)
          # shellcheck disable=2004
          val="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
          if [[ -z "$val" ]]; then
            echo "--target cannot be empty" && exit 1
          fi
          target="${val}"
          ;;
        target=*)
          val=${OPTARG#*=}
          if [[ -z "$val" ]]; then
            echo "--target cannot be empty" && exit 1
          fi
          target="${val}"
          ;;
          install)
            # shellcheck disable=2004
            val="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
            if [[ -z "$val" ]]; then
              echo "--install cannot be empty" && exit 1
            fi
            scripts="${val}"
            ;;
          install=*)
            val=${OPTARG#*=}
            if [[ -z "$val" ]]; then
              echo "--install cannot be empty" && exit 1
            fi
            opt=${OPTARG%=$val}
            scripts="${val}"
            ;;
          branch)
            # shellcheck disable=2004
            val="${!OPTIND}"; OPTIND=$(( OPTIND + 1 ))
            if [[ -z "$val" ]]; then
              echo "--branch cannot be empty" && exit 1
            fi
            branch="$val"
            ;;
          branch=*)
            val=${OPTARG#*=}
            if [[ -z "$val" ]]; then
              echo "--branch cannot be empty" && exit 1
            fi
            opt=${OPTARG%=$val}
            branch="$val"
            ;;
        *)
          if [ "$OPTERR" = 1 ] && [ "${optspec:0:1}" != ":" ]; then
            echo
            echo "  Unknown option \`--${OPTARG}\`" >&2
            echo -e "$usage"
            exit 1
          fi
          ;;
      esac;
      ;;
  f)
    force=true
    ;;
  l)
    pull=false
    ;;
  s)
    sync_only=true
    ;;
  d)
    dry_run=true
    ;;
  *)
    if [ "$OPTERR" != 1 ] || [ "${optspec:0:1}" = ":" ]; then
      echo
      echo "  Unknown option \`-${OPTARG}\`" >&2
      echo -e "$usage"
      exit 1
    fi
    ;;
  esac
done

shift $((OPTIND - 1))
[ "$1" = "--" ] && shift
unset val

# Source and define helpers
# ------------------------------------------------------------------------------

# shellcheck source=/dev/null
source .colors.sh

function _bot() {
  clr_bold clr_green "    .     "
  clr_bold clr_green " ~(0_0)~﻿  " -n; clr_bold "$@"
}

function _bot_error() {
  clr_bold clr_red "    .     "
  clr_bold clr_red " ~(0_0)~﻿  " -n; clr_bold clr_red "$@"
  echo
}

function _bot_exit() {
  clr_bold clr_cyan "    .     "
  clr_bold clr_cyan " ~(0_0)~﻿  " -n; clr_bold clr_cyan "Bot out!"
  echo
  _cleanup
  exit 0
}

function _align() {
  echo -n "        ﻿  "
}

function _rsync() {
  rsync "${rsync_exclude[@]/#/--exclude=}" -a -t -p --no-perms "$@" . "$target"
}

function _install_homebrew() {
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
}

function _pretty_rsync_change() {
  # Parse rsync `itemize` output in a `git status`-like manner
  local start_ cmd_ mod_ file_

  cmd_=""
  start_="${1:0:1}"
  mod_="${1:2:9}"
  file_="${1:13}"

  # shellcheck disable=2076
  if [[ ! "<>c" =~ "$start_" ]]; then
    return 0
  fi

  case "$mod_" in
    '+++++++')
      cmd_="clr_red 'MISSING ' -n"
      ;;
    '.st......'|'.s.......'|'..t......')
      # Rsync change state is qualified by git diff status as we only
      # care about content.
      git diff -s "$target/$file_" "$(pwd)/$file_" || cmd_="clr_blue 'UPDATED ' -n"
      ;;
  esac

  [[ ! -z "${cmd_}" ]] && eval "_align;$cmd_;echo $file_"
}

function check_changes() {
  # Get file change for known files (into the dotfiles repo) from rsync
  # and format them nicely
  local changes
  _bot "Checking for changed files against $target (this does not check for files deleted in the repo but not in the target)"
  changes=$(_rsync -i --dry-run)
  if [[ -z "${changes// }" ]]; then
    _bot "No change detected"
    _cleanup
    exit 0
  else
    _bot "Changes detected:"
    echo
    (IFS='
'
for x in $changes; do _pretty_rsync_change "$x"; done)
  fi
}

function _cleanup() {
  unset _rsync _install_homebrew check_changes _pretty_rsync_change
  unset _bot _align _bot_error _bot_exit
  unset force pull dry_run sync_only
  unset rsync_exclude scripts directories target
}

# ==============================================================================
# Install process
# ==============================================================================

echo
_bot "Starting bootstrap process in $(pwd) against $target (Install scripts: ${scripts})"

if [[ ! -d $scripts ]]; then
  _bot_error "Install scripts location '${scripts}' is not a directory"
  exit 1
fi

if [[ ! -d $target ]]; then
  _bot_error "Target '${target}' is not a directory"
  exit 1
fi

if $pull; then # -- Update dotfiles from git repo
  _bot "Updating from git"
  # shellcheck disable=SC2128,2164
  cd "$(dirname "${BASH_SOURCE[@]}")"
  [[ $? == 1 ]] && _bot_error "Error moving directories" && exit 1
  echo
  git pull origin "$branch"
  [[ $? == 1 ]] && _bot_error "Error running 'git pull origin master'" && exit 1
  echo
fi

if $dry_run; then  # -- Load and display (nice) diff
  check_changes
  _bot_exit
fi

# -- rsync the files to $HOME
_bot "rsync'ing files to your target directory ($target)..."
if $force; then
    echo
    _rsync -v
    [[ $? == 1 ]] && _bot_error "Error while rsync'ing yout files" && exit 1
else
    _align
    echo -n "This may overwrite existing files in your target directory ($target). Are you sure? (y/n) "
    read -rp "" -n 1
    if [[ $REPLY =~ ^[Yy]$ ]]; then
       echo
       _rsync -v
       [[ $? == 1 ]] && _bot_error "Error while rsync'ing yout files" && exit 1
    fi
fi

if $sync_only; then  # -- exit early
  _bot_exit
fi

echo
_bot "Creating extra directories"
echo
for dir in "${directories[@]}"; do
  _align; echo "- $target/$dir"
  mkdir -p "$target/$dir"
done

_bot "Installing xcode command line tools"
xcode-select --install || true

if [[ -z $(command -v brew) ]]; then
  if $force; then
    _bot "Installing Homebrew"
    echo
    _install_homebrew
  else
    _bot "Do you want to install Homebrew ? (y/n) " -n
    read -rp "" -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && echo && _install_homebrew || echo
  fi
else
  if $force; then
    _bot "Updating Homebrew"
    brew update
  else
    _bot "Homebrew is already installed, do you want to update it ? (y/n) " -n
    read -rp "" -n 1
    [[ $REPLY =~ ^[Yy]$ ]] && echo && brew update || echo
  fi
fi

_bot "Do you want to rename your computer (current name: $(scutil --get ComputerName))? (y/n) " -n
read -rp "" -n 1
[[ $REPLY =~ ^[Yy]$ ]] && echo && ./_rename-computer.sh

_bot "Processing install scripts in '$scripts'"
for file in "$scripts"/*; do
  if [[ ! -f $file ]]; then
    continue
  fi
  filename=$(basename "$file")

  if $force; then
    _align; echo "- Sourcing $filename"
    # shellcheck source=/dev/null
    . "./$file"
  else
    echo
    _align; echo -n "- Do you want to apply the $filename install script ? (y/n) "
    read -rp "" -n 1
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      echo
      # shellcheck source=/dev/null
      . "./$file"
      [[ $? == 1 ]] && _bot_error "Error processing $file" && exit 1
    fi
  fi
  echo
done

_bot_exit
