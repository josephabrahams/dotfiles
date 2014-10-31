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

    brew bundle $HOME/.dotfiles/init/Brewfile

Install OS X native apps:

    HOMEBREW_CASK_OPTS="--appdir=/Applications" brew bundle $HOME/.dotfiles/init/Caskfile

Set sensible hacker defaults for OS X:

    $HOME/.dotfiles/init/osx.sh

Install Python dependencies:

    pip install -r $HOME/.dotfiles/init/requirements.txt

Install/update most other dependencies:

    $HOME/.dotfiles/init/bootstrap.sh

Install the dotfiles, oh-my-zsh, and vim plugins:

    RCRC=$HOME/.dotfiles/rcrc rcup -fv

Add brewed bash and zsh to `/etc/shells`:

    sudo sh -c "echo '/usr/local/bin/bash\n/usr/local/bin/zsh' >> /etc/shells"

Set brewed zsh as your login shell:

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
* [Mathias Bynens](http://joseph.is/104CHsR)
* [Mike Losh](http://joseph.is/1zNYLIu)
* [Square](http://joseph.is/1FZKGbF)
* [Thoughtbot](http://joseph.is/1FZKRUl)
* and many more...

