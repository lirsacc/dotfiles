# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
    [ -r "$file" ] && [ -f "$file" ] && source "$file"
done
unset file

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Append to the Bash history file, rather than overwriting it
shopt -s histappend

# Autocorrect typos in path names when using `cd`
shopt -s cdspell

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
    shopt -s "$option" 2> /dev/null
done

# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2 | tr ' ' '\n')" scp sftp ssh

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults

# If possible, add tab completion for many more commands
[ -f /etc/bash_completion ] && source /etc/bash_completion

if [ -f `brew --prefix git`/etc/bash_completion.d/git-completion.bash ]; then
  source `brew --prefix git`/etc/bash_completion.d/git-completion.bash
elif [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi

# Load NVM
export NVM_DIR="$HOME/.nvm"
if [ -f `brew --prefix nvm`/nvm.sh ]; then
  source $(brew --prefix nvm)/nvm.sh
elif [ -f ~/.nvm/nvm.sh ]; then
  source ~/.nvm/nvm.sh
fi

# PYTHON virtualenv specifics
export WORKON_HOME="$HOME/.pyenvs"
[[ -f $(brew --prefix)/bin/virtualenvwrapper.sh ]] && source $(brew --prefix)/bin/virtualenvwrapper.sh

# PYTHON miniconda
export CONDA_PATH="$HOME/.conda"
export PATH="$HOME/.conda/bin:$PATH"
