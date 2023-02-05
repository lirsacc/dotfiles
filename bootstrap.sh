#!/usr/bin/env bash

# Safer bash script
set -eo pipefail

# Uncomment for debug information
# set -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

scripts="${SCRIPT_DIR}/install"
target="${HOME}"
extra_directories=("projects")
branch="master"

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
  --no-update         Only sync new file, not changes
  --no-links          Do not sync symlinks

  --target            Use this location instead of \$HOME ($HOME), must be a directory
  --install           Where to look for install scripts [default: ${scripts}]
  --branch            Git branch to update from [default: ${branch}]
  "

if ! [[ "$OSTYPE" =~ darwin* ]]; then
    echo "This is meant to be run on macOS and will probably break on other systems."
    exit
fi

# Read the options
# ------------------------------------------------------------------------------

OPTIND=1

force=false
pull=true
sync_only=false
no_update=false
no_links=false
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
                no-update)
                    no_update=true
                    ;;
                no-links)
                    no_links=true
                    ;;
                dry-run)
                    dry_run=true
                    ;;
                target)
                    # shellcheck disable=2004
                    val="${!OPTIND}"
                    OPTIND=$((OPTIND + 1))
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
                    val="${!OPTIND}"
                    OPTIND=$((OPTIND + 1))
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
                    val="${!OPTIND}"
                    OPTIND=$((OPTIND + 1))
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
            esac
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

if [ "$1" = "--" ]; then shift; fi

unset val

# ==============================================================================
# Utils
# ==============================================================================

# shellcheck source=/dev/null
source .colors.sh

# shellcheck source=/dev/null
source .bot.sh

function _install_homebrew() {
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

rsync_exclude=(
    ".git/"
    "install"
    "${scripts}"
    ".colors.sh"
    ".bot.sh"
    "bootstrap.sh"
    ".DS_Store"
    "README.md"
    "LICENSE-MIT.txt"
    ".gitkeep"
    ".Trash"
)

rsync_flags=(
    --archive
    --partial
    --progress
    --ignore-times
    --checksum
    --no-perms
    --executability
    --recursive
    --human-readable
)

for x in ${rsync_exclude[*]}; do
    rsync_flags+=( "--exclude=$x" )
done

if [[ "$no_update" == "true" ]]; then
    rsync_flags+=( --ignore-existing )
fi

if [[ "$no_links" == "true" ]]; then
    rsync_flags+=( --no-links )
else
    rsync_flags+=(
        --links
        --safe-links
    )
fi

function _rsync() {
    rsync ${rsync_flags[@]} "$@" . "$target"
}

function _prettify_rsync_output() {
    local _update __type _path _mod

    # Transform rsync `itemize` output in a `git status`-like manner
    _update="${1:0:1}"
    _type="${1:1:1}"
    _path="${1:10}"
    _mod="${1:2:7}"

    if [[ "$_update" == "." ]] || [[ "$_type" == "d" ]] || [[ "$_mod" == "..t...." ]]; then
        return 0
    fi

    if [[ "$_mod" == "+++++++" ]]; then
        _align && clr_bold clr_green "CREATE " -n && echo "$_path"
    elif [[ "$_mod" == c* ]]; then # Checksum differs
        _align && clr_bold clr_blue "UPDATE " -n && echo "$_path"
    elif [[ "$_update$_type" == "cL" ]]; then  # New symlink
        _align && clr_bold clr_blue "UPDATE " -n && echo "$_path"
    fi
}

function check_changes() {
    # Get file change for known files (into the dotfiles repo) from rsync
    # and format them nicely
    local changes
    _bot "Checking for changed files against $target"
    _bot "WARN: this does not check for files deleted in the repo but not in the target"

    readarray -t changes < <(_rsync -i --dry-run)
    IFS=$'\n' read -r -d '' -a changes < <(_rsync --itemize-changes --dry-run && printf '\0')

    if ! (( ${#changes[@]} )); then
        _bot "No change detected"
        exit 0
    else
        _bot "Changes detected:"
        echo
        IFS=''
        for x in ${changes[*]}; do
            _prettify_rsync_output "$x"
        done
    fi
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
    [[ $? == 1 ]] && _bot_error "Error running 'git pull origin $branch'" && exit 1
    echo
fi

if $dry_run; then # -- Load and display (nice) diff
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

if $sync_only; then # -- exit early
    _bot_exit
fi

echo
_bot "Creating extra directories"
echo
for dir in "${directories[@]}"; do
    _align
    echo "- $target/$dir"
    mkdir -p "$target/$dir"
done

_bot "Installing xcode command line tools"
xcode-select --install || true
sudo xcodebuild -license accept || true

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
[[ $REPLY =~ ^[Yy]$ ]] && echo && ./.rename-computer.sh

_bot "Processing install scripts in '$scripts'"
for file in "$scripts"/*; do
    if [[ ! -f $file ]]; then
        continue
    fi
    filename=$(basename "$file")

    if $force; then
        _align
        echo "- Sourcing $filename"
        # shellcheck source=/dev/null
        . "./$file"
    else
        echo
        _align
        echo -n "- Do you want to apply the $filename install script ? (y/n) "
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
