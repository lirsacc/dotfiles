#!/usr/bin/env zsh

autoload -Uz compinit

export TERM="xterm-256color"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR="vim"
export VISUAL_EDITOR="code -a -w"

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
export GPG_TTY=(tty)

# Highlight section titles in manual pages
# highlighting inside manpages and elsewhere
export LESS_TERMCAP_mb=\e'[01;31m'       # begin blinking
export LESS_TERMCAP_md=\e'[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=\e'[0m'           # end mode
export LESS_TERMCAP_se=\e'[0m'           # end standout-mode
export LESS_TERMCAP_so=\e'[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=\e'[0m'           # end underline
export LESS_TERMCAP_us=\e'[04;38;5;146m' # begin underline

# Don’t clear the screen after quitting a manual page
export MANPAGER="less -X"

# Always use color output for `ls`
export LS_COLORS='no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_BUILD_FROM_SOURCE=0
export HOMEBREW_NO_EMOJI=1
export HOMEBREW_NO_ANALYTICS=1

export HOMEBREW_PREFIX="/opt/homebrew"
export HOMEBREW_CELLAR="$HOMEBREW_PREFIX/Cellar"
export HOMEBREW_REPOSITORY="/opt/homebrew"

export PATH="\
$HOMEBREW_PREFIX/bin:\
$HOMEBREW_PREFIX/sbin:\
$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin:\
$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:\
$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin:\
$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin:\
$HOMEBREW_PREFIX/opt/grep/libexec/gnubin:\
$HOMEBREW_PREFIX/opt/make/libexec/gnubin:\
$PATH"

export MANPATH="$HOMEBREW_PREFIX/share/man:$MANPATH"
export INFOPATH="$HOMEBREW_PREFIX/share/info:$INFOPATH"

export PKG_CONFIG_PATH="\
$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig \
$PKG_CONFIG_PATH"

export LDFLAGS="\
-L$HOMEBREW_PREFIX/lib \
-L$HOMEBREW_PREFIX/opt/curl/lib \
$LDFLAGS"

export LDFLAGS="\
-L$HOMEBREW_PREFIX/lib \
-L$HOMEBREW_PREFIX/opt/curl/lib \
$LDFLAGS"

_CFLAGS="\
-I$HOMEBREW_PREFIX/include \
-I$HOMEBREW_PREFIX/opt/curl/include \
"

export CFLAGS="$_CFLAGS $CFLAGS"
export CPPFLAGS="$_CFLAGS $CPPFLAGS"

export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/bin:$PATH"

command -v rg >/dev/null && export FZF_DEFAULT_COMMAND='rg --files --hidden'

eval "$(direnv hook zsh)"
source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

eval "$(starship init zsh)"

[[ -f "${HOME}/.config/.aliases.sh" ]] && source "${HOME}/.config/.aliases.sh"

[[ -f "${HOME}/.local.zsh" ]] && source "${HOME}/.local.zsh"

unsetopt CORRECT

HISTDUP=erase           # Erase duplicates in the history file
setopt appendhistory    # Append history to the history file (no overwriting)
setopt sharehistory     # Share history across terminals
setopt incappendhistory # Immediately append to the history file, not just when a term is killed

bindkey '^U' backward-kill-line
