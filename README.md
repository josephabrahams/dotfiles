Joseph does dotfiles
====================


Requirements
------------

Install [Homebrew](http://brew.sh/):

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

Install [Oh My Zsh](http://ohmyz.sh/):

    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh

Install [Zsh Syntax Highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/):

    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.zsh/custom/plugins/zsh-syntax-highlighting

Install [Base16](http://chriskempson.github.io/base16/):

    git clone https://github.com/chriskempson/base16-iterm2.git $HOME/.config/base16-iterm2
    git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell

Install [Composer](https://getcomposer.org):

    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer

Install [WordPress Coding Standards](https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards):

    git clone -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git $HOME/.config/WordPress-Coding-Standards


Install
-------

Clone onto your laptop:

    git clone https://github.com/josephabrahams/dotfiles.git $HOME/.dotfiles

Install command-line tools:

    brew bundle $HOME/.dotfiles/Brewfile 2>/dev/null

Install OS X native apps:

    brew bundle $HOME/.dotfiles/Caskfile 2>/dev/null

Install the dotfiles:

    RCRC=$HOME/.dotfiles/rcrc rcup -fv

Install Python dependencies:

    pip install -r $HOME/.dotfiles/requirements.txt

Install PHP dependencies:

    composer global install
    phpcs --config-set installed_paths $HOME/.config/WordPress-Coding-Standards

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

