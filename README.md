Joseph does dotfiles
====================


Requirements
------------

Install [Homebrew](http://brew.sh/):

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install [oh-my-zsh](http://ohmyz.sh/):

    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh

Install [Base16](http://chriskempson.github.io/base16/):

    git clone https://github.com/chriskempson/base16-iterm2.git $HOME/.config/base16-iterm2
    git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell


Install
-------

Clone onto your laptop:

    git clone https://github.com/josephabrahams/dotfiles.git $HOME/.dotfiles

Install command-line tools:

    brew bundle $HOME/.dotfiles/Brewfile 2>/dev/null

Install OS X native apps:

    brew bundle $HOME/.dotfiles/Caskfile 2>/dev/null

Install the Python dependencies:

    pip install -r $HOME/.dotfiles/requirements.txt

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

Configure iTerm2:

* Install the Base16 Default theme in Profiles > Colors > Load Presets > Import
    * ~/.config/base16-iterm2/base16-default.dark.256.itermcolors
* Under Profiles > Terminal
    * Set Scrollback Lines to 0 if you are using tmux.
    * Set Report Terminal Type to xterm-256color.
* Under Profiles > Text
    * Disable Draw bold text in bright colors.


Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.zshrc.local`


## Credits
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
* [Thoughtbot](https://github.com/thoughtbot/dotfiles)
* [Square](https://github.com/square/maximum-awesome)
* and many more.
