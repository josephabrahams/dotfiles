Joseph does dotfiles
====================


Requirements
------------

Set zsh as your login shell:

    chsh -s $(which zsh)


Install
-------

Clone onto your laptop:

    git clone git@github.com:josephabrahams/dotfiles.git $HOME/.dotfiles

Install [rcm](https://github.com/thoughtbot/rcm):

    brew bundle $HOME/.dotfiles/Brewfile

Install the dotfiles:

    RCRC=$HOME/.dotfiles/rcrc rcup

This command will create symlinks for config files in your home directory.
Setting the `RCRC` environment variable tells `rcup` to use standard
configuration options:

* Exclude the `README.md`, `LICENSE`, and `Brewfile` files, which are part of
  the `dotfiles` repository but do not need to be symlinked in.

You can safely run `rcup` multiple times to update:

    rcup


## Credits
- [Thoughtbot](https://github.com/thoughtbot/dotfiles)
- and many more.
