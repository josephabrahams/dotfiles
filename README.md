Joseph does dotfiles
====================


Requirements
------------

Install [Homebrew](http://brew.sh/):

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install [oh-my-zsh](http://ohmyz.sh/):

    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh


Install
-------

Clone onto your laptop:

    git clone git@github.com:josephabrahams/dotfiles.git $HOME/.dotfiles

Install command-line tools:

    brew bundle $HOME/.dotfiles/Brewfile

Install OS X native apps:

    brew bundle $HOME/.dotfiles/Caskfile

Install the dotfiles:

    RCRC=$HOME/.dotfiles/rcrc rcup

This command will create symlinks for config files in your home directory.
Setting the `RCRC` environment variable tells `rcup` to use standard
configuration options:

* Exclude the `README.md`, `LICENSE`, `Brewfile`, and `Caskfile` files, which are part of
  the `dotfiles` repository but do not need to be symlinked in.

You can safely run `rcup` multiple times to update:

    rcup

Add the following lines to `/etc/shells`:

    /usr/local/bin/bash
    /usr/local/bin/zsh

Set zsh as your login shell:

    chsh -s /usr/local/bin/zsh


Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.zshrc.local`


## Credits
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
* [oh-my-zsh](https://github.com/robbyrussell/oh-my-zsh)
* [Thoughtbot](https://github.com/thoughtbot/dotfiles)
* [Square](https://github.com/square/maximum-awesome)
* and many more.
