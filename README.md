Joseph does dotfiles
====================


Requirements
------------

Set zsh as your login shell:

    chsh -s $(which zsh)

Install [oh-my-zsh](http://ohmyz.sh/):

    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh


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


Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.zshrc.local`


## Credits
- [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
- [Thoughtbot](https://github.com/thoughtbot/dotfiles)
- and many more.
