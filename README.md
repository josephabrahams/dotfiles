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

* `Preferences...` &rarr; `Profiles` &rarr; `Colors` &rarr; `Load Presets...` &rarr; `base16-default.dark.256`

* `Preferences...` &rarr; `Keys` &rarr; `Global Key Shortcuts`
    * `+` Keyboard Shortcut: `Control+Tab`, Action: `Next Tab`
    * `+` Keyboard Shortcut: `Control+Shift+Tab`, Action `Previous Tab`

Configure Karabiner:

&#x2713; all options under `Custom Settings` and:

* `Control_L to Control_L (+ When you type Control_L only, send Escape)`
* `Control+Delete to Forward Delete`
* `Shift+Delete to Forward Delete (if no other modifiers pressed)`
* `Use "hjkl" keys as arrow keys if you are not editing text.`
* Delay Until Repeat: 300ms
* Key Repeat: 30ms
* Key Overlaid Modifier Timeout: 200ms


Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.gitconfig.local`
* `~/.zshenv.local`
* `~/.zshrc.local`


## Inspired by
* [Mathias Bynens](http://joseph.is/104CHsR)
* [Mike Losh](http://joseph.is/1zNYLIu)
* [Mike Solomon](http://joseph.is/1sLgmai)
* [Yan Pritzker](http://joseph.is/1yNOLLe)
* [Square](http://joseph.is/1FZKGbF)
* [Thoughtbot](http://joseph.is/1FZKRUl)
* and many more...

