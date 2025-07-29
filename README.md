dotfiles
========

- Originally forked from Mathias Bynens's great [dotfiles repo](https://github.com/mathiasbynens/dotfiles), now detached.
- OSX only, setup for >M1 Macs (where homebrew install location changed).
- Primary shell is [fish](https://fishshell.com/).
- Use [chezmoi](https://www.chezmoi.io/) for management.

Setup
-----

1. Install [homebrew](https://brew.sh/)
2. Install [chezmoi](https://www.chezmoi.io/) (`brew install chezmoi` works)
3. Create a `~/.config/chezmoi/chezmoi.toml` file:

  ```toml
  # Your chezmoi settings

  [data]
      git_email = "<your git email>"
      git_name = "<your git name>"
      git_signingkey = "<the git ssh signing key id>"
      hostname = "<hostname>"  # Remove to leave hostname alone
      run_osx_setup = "false"  # Set to true to automaticallt run the osx setup script
  ```
3. Run `chezmoi init lirsacc` and `chezmoi apply`
