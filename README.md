Joseph does dotfiles
====================


Requirements
------------

Install [Homebrew](http://brew.sh/):

    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew tap homebrew/boneyard


Install
-------

Clone the dotfiles repo:

    git clone https://github.com/josephabrahams/dotfiles.git $HOME/.dotfiles

Install command-line tools:

    brew bundle $HOME/.dotfiles/Brewfile

Install OS X native apps:

    HOMEBREW_CASK_OPTS="--appdir=/Applications" brew bundle $HOME/.dotfiles/Caskfile

Install Python dependencies:

    pip install -r $HOME/.dotfiles/requirements.txt

Install the dotfiles & dependencies:

    RCRC=$HOME/.dotfiles/rcrc rcup -fv

Add brewed bash and zsh to `/etc/shells`:

    sudo sh -c "echo '/usr/local/bin/bash\n/usr/local/bin/zsh' >> /etc/shells"

Set zsh as your login shell:

    chsh -s /usr/local/bin/zsh

Configure iTerm2:

    open /Applications/iTerm.app

1. Naviate to `Preferences...` &rarr; `Profiles` &rarr; `Colors` &rarr; `Load Presets...` &rarr; `Import...`
2. Use Command+Shift+. to display hidden files in the Open dialogue
3. Select `~/.config/base16-iterm2/base16-default.dark.256.itermcolors`


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

