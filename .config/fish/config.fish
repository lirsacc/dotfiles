set -gx fish_greeting ''

# Shell convenience aliases
alias unset "set -e"
alias path 'echo $PATH | tr -s " " "\n"'
alias h "history"

set -gx TERM "xterm-256color"

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -gx EDITOR "vim"
set -gx VISUAL_EDITOR "code -a -w"

set -g fish_emoji_width 2

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
set -gx GPG_TTY (tty)

# Highlight section titles in manual pages
# highlighting inside manpages and elsewhere
set -gx LESS_TERMCAP_mb \e'[01;31m'       # begin blinking
set -gx LESS_TERMCAP_md \e'[01;38;5;74m'  # begin bold
set -gx LESS_TERMCAP_me \e'[0m'           # end mode
set -gx LESS_TERMCAP_se \e'[0m'           # end standout-mode
set -gx LESS_TERMCAP_so \e'[38;5;246m'    # begin standout-mode - info box
set -gx LESS_TERMCAP_ue \e'[0m'           # end underline
set -gx LESS_TERMCAP_us \e'[04;38;5;146m' # begin underline

# Don’t clear the screen after quitting a manual page
set -gx MANPAGER "less -X"

# Always use color output for `ls`
set -gx LS_COLORS 'no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_BUILD_FROM_SOURCE 0
set -gx HOMEBREW_NO_EMOJI 1
set -gx HOMEBREW_NO_ANALYTICS 1

set -gx HOMEBREW_PREFIX "/opt/homebrew"
set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
set -gx HOMEBREW_REPOSITORY "/opt/homebrew"

set -gx PATH \
"$HOMEBREW_PREFIX/bin" \
"$HOMEBREW_PREFIX/sbin" \
"$HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin" \
"$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin" \
"$HOMEBREW_PREFIX/opt/gnu-tar/libexec/gnubin" \
"$HOMEBREW_PREFIX/opt/gnu-which/libexec/gnubin" \
"$HOMEBREW_PREFIX/opt/grep/libexec/gnubin" \
"$HOMEBREW_PREFIX/opt/make/libexec/gnubin" \
$PATH;

set -q MANPATH; or set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
set -q INFOPATH; or set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;

set -q LDFLAGS; or set LDFLAGS '';

# Other not added for now: libffi, binutils, openssl@1.1, openssl@3. zlip

set -gx LDFLAGS \
"-L$HOMEBREW_PREFIX/lib" \
"-L$HOMEBREW_PREFIX/opt/curl/lib" \
$LDFLAGS;

set _CFLAGS \
"-I$HOMEBREW_PREFIX/include" \
"-I$HOMEBREW_PREFIX/opt/curl/include";

set -q CPPFLAGS; or set CPPFLAGS '';
set -gx CPPFLAGS $_CFLAGS $CPPFLAGS;

set -q CFLAGS; or set CFLAGS '';
set -gx CFLAGS $_CFLAGS $CFLAGS;

set -q PKG_CONFIG_PATH; or set PKG_CONFIG_PATH '';
set -gx PKG_CONFIG_PATH \
"$HOMEBREW_PREFIX/opt/curl/lib/pkgconfig" \
$PKG_CONFIG_PATH;

set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/bin $PATH

command -v rg >/dev/null && set -gx FZF_DEFAULT_COMMAND 'rg --files --hidden'

set -g direnv_fish_mode disable_arrow
direnv hook fish | source

source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.fish"

if status is-interactive
    # Commands to run in interactive sessions can go here
    if test -d (brew --prefix)"/share/fish/completions"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/completions
    end

    if test -d (brew --prefix)"/share/fish/vendor_completions.d"
        set -gx fish_complete_path $fish_complete_path (brew --prefix)/share/fish/vendor_completions.d
    end

    starship init fish | source
end

source ~/.config/fish/utils.fish

source ~/.config/.aliases.sh

if test -e ~/.extras.fish
    source ~/.extras.fish
end

