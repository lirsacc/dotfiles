set -gx fish_greeting ''

# Shell convenience aliases
alias unset "set -e"
alias reload 'exec $SHELL -l'
alias path 'echo $PATH | tr -s " " "\n"'
alias h "history"

set -gx TERM "xterm-256color"

set -gx LC_ALL en_US.UTF-8
set -gx LANG en_US.UTF-8

set -gx EDITOR "vim"
set -gx VISUAL_EDITOR "code"
# set -gx EDITOR (which code) -w

# Prompt
set -gx SPACEFISH_NODE_SHOW false
set -gx SPACEFISH_JULIA_SHOW false
set -gx SPACEFISH_DOCKER_SHOW false
set -gx SPACEFISH_RUBY_SHOW false
set -gx SPACEFISH_HASKELL_SHOW false
set -gx SPACEFISH_CONDA_SHOW false
set -gx SPACEFISH_ELIXIR_SHOW false
set -gx SPACEFISH_PYENV_SHOW false
set -gx SPACEFISH_GOLANG_SHOW false
set -gx SPACEFISH_PHP_SHOW false
set -gx SPACEFISH_DOTNET_SHOW false

set -gx SPACEFISH_BATTERY_SHOW false

set -gx SPACEFISH_GIT_STATUS_SHOW false

set -gx SPACEFISH_VENV_SYMBOL '🐍 '
set -gx SPACEFISH_CHAR_SYMBOL '❯'
set -gx SPACEFISH_PROMPT_ADD_NEWLINE false

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

set -gx MANPATH /usr/local/share/man $MANPATH
set -gx INFOPATH /usr/local/share/info $INFOPATH

set -gx PATH /usr/local/bin:/usr/local/sbin $PATH
set -gx PATH $HOME/bin $PATH

# Avoid issues with `gpg` as installed via Homebrew.
# https://stackoverflow.com/a/42265848/96656
set -gx GPG_TTY (tty)

# Always use color output for `ls`
set -gx LS_COLORS 'no=00:fi=00:di=01;34:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'

set -gx HOMEBREW_NO_AUTO_UPDATE 1
set -gx HOMEBREW_BUILD_FROM_SOURCE 0
set -gx HOMEBREW_NO_EMOJI 1
set -gx HOMEBREW_NO_ANALYTICS 1
set -gx HOMEBREW_CASK_OPTS --appdir=/Applications

# Homebrew replacements of OS X installed tools.
set -gx MANPATH /usr/local/opt/coreutils/libexec/gnuman $MANPATH
set -gx MANPATH /usr/local/opt/grep/libexec/gnuman $MANPATH
set -gx MANPATH /usr/local/opt/make/libexec/gnuman $MANPATH

set -gx LDFLAGS "-L/usr/local/opt/flex/lib"
set -gx LDFLAGS "-L/usr/local/opt/libressl/lib"

set -gx CPPFLAGS "-I/usr/local/opt/flex/include"
set -gx CPPFLAGS "-I/usr/local/opt/libressl/include"
set -gx LDFLAGS "-L/usr/local/opt/bison/lib"

set -gx PATH /usr/local/opt/coreutils/libexec/gnubin $PATH
set -gx PATH /usr/local/opt/gnu-sed/libexec/gnubin $PATH
set -gx PATH /usr/local/opt/make/libexec/gnubin $PATH
set -gx PATH /usr/local/opt/bison/bin $PATH
set -gx PATH /usr/local/opt/flex/bin $PATH
set -gx PATH /usr/local/opt/grep/libexec/gnubin $PATH
set -gx PATH /usr/local/opt/libressl/bin $PATH
set -gx PATH /usr/local/opt/m4/bin $PATH
set -gx PATH /usr/local/opt/unzip/bin $PATH

set -gx PKG_CONFIG_PATH "/usr/local/opt/libressl/lib/pkgconfig"

set -gx PATH $HOME/.cargo/bin $PATH
set -gx NVM_DIR $HOME/.nvm

# Python
set -gx PATH /usr/local/opt/python/libexec/bin $PATH
set -gx PYENV_ROOT $HOME/.pyenv
set -gx fish_user_paths $PYENV_ROOT/bin $fish_user_paths
pyenv init - | source

command -v ag >/dev/null && set -gx FZF_DEFAULT_COMMAND 'ag --literal --files-with-matches --nocolor --hidden -g ""'

source ~/.config/fish/utils.fish

set PROJECTS "$HOME/projects"
alias p "cd $HOME/projects"
