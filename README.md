Joseph does dotfiles
====================


Requirements
------------

Install [Homebrew](http://brew.sh/):

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install [oh-my-zsh](http://ohmyz.sh/):

    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh

Install [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/):

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH/custom/plugins/zsh-syntax-highlighting

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

Install Python dependencies:

    pip install -r $HOME/.dotfiles/requirements.txt

Install the dotfiles:

    RCRC=$HOME/.dotfiles/rcrc rcup -fv

Add the following lines to `/etc/shells`:

    /usr/local/bin/bash
    /usr/local/bin/zsh

Set zsh as your login shell:

    chsh -s /usr/local/bin/zsh

Configure iTerm2:

    /usr/libexec/PlistBuddy -c "Add: 'Custom Color Presets':'base16-default.dark.256' dict" ~/Library/Preferences/com.googlecode.iterm2.plist
    /usr/libexec/PlistBuddy -c "Merge '$HOME/.config/base16-iterm2/base16-default.dark.256.itermcolors' :'Custom Color Presets':'base16-default.dark.256'" ~/Library/Preferences/com.googlecode.iterm2.plist


Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.gitconfig.local`
* `~/.zshrc.local`


## Inspired by
* [Mathias Bynens](https://github.com/mathiasbynens/dotfiles)
* [Mike Solomon](http://msol.io/blog/tech/2014/03/10/work-more-efficiently-on-your-mac-for-developers/)
* [Square](https://github.com/square/maximum-awesome)
* [Thoughtbot](https://github.com/thoughtbot/dotfiles)
* and many more...

