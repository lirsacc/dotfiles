dotfiles
========

- Originally forked from Mathias Bynens's great [dotfiles repo](https://github.com/mathiasbynens/dotfiles), now [detached](https://github.com/lirsacc/dotfiles/commit/54eb6ed1b0a41510914b521b1542c18e96a37675).
- OSX only, setup for >M1 Macs (where homebrew install location changed).
- Primary shell is [fish](https://fishshell.com/).
- Use [chezmoi](https://www.chezmoi.io/) for management.

Setup
-----

1. Install [homebrew](https://brew.sh/)
2. Install [chezmoi](https://www.chezmoi.io/) (`brew install chezmoi` works)
3. (optional) Create a `~/.config/chezmoi/chezmoi.toml` file:

  ```toml
  # Your chezmoi settings

  [data]
      # Set these to start with a default Git identity
      git_email = "<your git email>"
      git_name = "<your git name>"
      git_signingkey = "<the git ssh signing key id>"

      hostname = "<hostname>"  # Remove to leave hostname alone

      run_osx_setup = "false"  # Set to `false` to automatically run the osx setup script, defaults enabled

      # Set to `true` or remove to enable application installation through mas, defaults enabled
      brew_skip_mas = "<true | false>"
      brew_skip_casks = "<true | false>"

      onepassword_agent_keys = [
        {vault = "<vault name>", item = "<key name>"},
        ...
      ]
  ```
3. Run `chezmoi init lirsacc` and `chezmoi apply`

Notes
-----

### Split homebrew bundle files

I couldn't find a way to easily disable all mas or all casks. The `$HOMEBREW_BUNDLE_*_SKIP` variables seem to want a list of specific entries and setting the to `1` doesn't do anything. There are also a `--mas` or `--casks` option but `--no-mas` / `--no-casks` aren't a thing.

The workaround is to split the brewfiles and not use a global one. This makes it a bit more cumbersome to do things like `brew bundle cleanup` or simply install all the things but `brew bundle --file -` does work with stdin so this works:

```shell
cat ~/.config/homebrew/Brewfile* | brew bundle --file -
```

```shell
cat ~/.config/homebrew/Brewfile* | brew bundle --file - cleanup
```

This works for my setup where I don't constantly add / remove things from the Brew bundle.

### Mise vs homebrew

It's a bit fuzzy where I use `mise` vs. `brew` to install something, and sometimes there's both but generally mise is used when it's likely I'll need different versions across different projects.

On individual machines I can create a `~/.mise.toml` to record machine specific tools & overrides to be used.

### Git config

- A default identity can be configured through the chezmoi data.
- This uses 1Password for loading SSH keys by default.
- You can also create a `~/.config/git/overrides.gitconfig` file locally which won't be managed and is loaded last.

#### Git config & identity per directory

A pattern I use often is to have a git identity per directory (e.g. one per GitHub organisation, GitHub instance, etc.). You can achieve this by adding blocks like this in the gitconfig:

```gitconfig
[includeIf "gitdir:~/projects/my-organisation/"]
  path = ~/projects/my-organisation/.gitconfig
```

I haven't found a way to automatically detect those, although something could probably be hacked around through the same prompt-hacks tools mise use to detect the closest config file.
