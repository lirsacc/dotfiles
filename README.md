Dotfiles
========

Originally forked from Mathias Bynens's great [dotfiles repo](https://github.com/mathiasbynens/dotfiles).

Usage
-----

    $ ./bootstrap.sh --help

                                               .
    Your friendly dotfiles bootstraper bot  ~(0_0)~

    bootstrap.sh [options]

    Options and arguments:

      -h, --help          Display this help text
      -d, --dry-run       Perform a dry run of the sync step
      -f, --force         Force overwrite files in target directory
      -l, --local         Use local repo only and do not update from git
      -s, --no-install    Sync only and doesn't run the install scripts

      --target            Use this location instead of $HOME (/Users/lirsacc), must be a directory
      --install           Look for install scripts there instead of /Users/lirsacc/projects/dotfiles/install
      --branch            Git branch to update from
