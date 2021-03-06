Joseph does dotfiles
====================

Requirements
------------

Xcode installed from the App Store (make sure to accept the license agreement):

```bash
sudo xcodebuild -license accept
```

[Homebrew](http://brew.sh/):

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Installation
------------

Clone the dotfiles repo:

```bash
git clone https://github.com/josephabrahams/dotfiles.git $HOME/.dotfiles
```

Install/update most other dependencies:

```bash
$HOME/.dotfiles/scripts/install
```

Install Node.js dependencies:
```bash
nvm alias default system
npm -g install eslint
```

Install PHP dependencies:
```bash
composer global install
```

Install Ruby dependencies:
```bash
gem install foreman tmuxinator
```

iTerm2 Preferences
------------------

* Profiles Tab:
    * `Colors` &rarr; `Load Presets...` &rarr; `base16-default.dark.256`

* Keys Tab:
    * `Key Mappings`
        * `+` Keyboard Shortcut: `Control+Tab`, Action: `Next Tab`
        * `+` Keyboard Shortcut: `Control+Shift+Tab`, Action `Previous Tab`

Make your own customizations
----------------------------

Put your customizations in dotfiles appended with `.local`:

* `~/.gitconfig.local`
* `~/.mutt/muttrc.local`
* `~/.vimrc.local`
* `~/.zshrc.local`

Inspired by
-----------

* [Mathias Bynens](http://joseph.is/104CHsR)
* [Mike Losh](http://joseph.is/1zNYLIu)
* [Mike Solomon](http://joseph.is/1sLgmai)
* [Yan Pritzker](http://joseph.is/1yNOLLe)
* [Square](http://joseph.is/1FZKGbF)
* [Thoughtbot](http://joseph.is/1FZKRUl)
* and many more...
