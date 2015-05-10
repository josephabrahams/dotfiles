#!/bin/sh
# install/upgrade all the things

bold='\033[1m'
unbold='\033[0m'

# Make common directories
ln -sf $HOME/.bin $HOME/bin &>/dev/null
ln -sf $HOME/Dropbox\ \(Personal\) $HOME/Dropbox &>/dev/null
mkdir -p $HOME/.nvm 2>/dev/null
ln -shf $(brew --prefix nvm)/nvm-exec $HOME/.nvm/nvm-exec
ln -shf $(brew --prefix nvm)/nvm.sh $HOME/.nvm/nvm.sh
mkdir -p $HOME/Projects 2>/dev/null
mkdir -p $HOME/tmp 2>/dev/null
[ -e $HOME/Dropbox ] && mkdir -p $HOME/Dropbox/.tmuxinator 2>/dev/null

# Homebrew - http://joseph.is/1DCbIBY
echo "\n${bold}Updating Homebrew formulas...${unbold}"
brew update
echo "\n${bold}Upgrading installed brews...${unbold}"
brew upgrade
echo "\n${bold}Remove unneeded brews...${unbold}"
brew cleanup

# Oh My Zsh
if [ -z "$ZSH" ]; then
    echo "\n${bold}Install Oh My Zsh...${unbold}"
    curl -L http://install.ohmyz.sh | ZSH=$HOME/.zsh sh
fi

# Zsh Syntax Highlighting - http://joseph.is/1yPtYtq
if [ -d $HOME/.zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "\n${bold}Updating Zsh Syntax Highlighting...${unbold}"
    cd $HOME/.zsh/custom/plugins/zsh-syntax-highlighting; git pull
else
    echo "\n${bold}Installing Zsh Syntax Highlighting...${unbold}"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        $HOME/.zsh/custom/plugins/zsh-syntax-highlighting
fi

# Base16 color scheme - http://joseph.is/11RoQHA
if [ -d $HOME/.config/base16-iterm2 ]; then
    echo "\n${bold}Updating Base16 iTerm2 color scheme...${unbold}"
    cd $HOME/.config/base16-iterm2; git pull
else
    echo "\n${bold}Installing Base16 iTerm2 color scheme...${unbold}"
    git clone https://github.com/chriskempson/base16-iterm2.git $HOME/.config/base16-iterm2
fi
if [ -d $HOME/.config/base16-shell ]; then
    echo "\n${bold}Updating Base16 shell color scheme...${unbold}"
    cd $HOME/.config/base16-shell; git pull
else
    echo "\n${bold}Installing Base16 shell color scheme...${unbold}"
    git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
fi

# JavaScript - http://joseph.is/1p6nO5g
if [ $(which npm 2>/dev/null) ]; then
    # echo "\n${bold}Updating NPM...${unbold}"
    # npm -g update
    if [ ! $(which bower 2>/dev/null) ]; then
        echo "\n${bold}Installing Bower...${unbold}"
        npm -g install bower
    fi
    if [ ! $(which jshint 2>/dev/null) ]; then
        echo "\n${bold}Installing JSHint...${unbold}"
        npm -g install jshint
    fi
    if [ ! $(which keybase 2>/dev/null) ]; then
        echo "\n${bold}Installing Keybase...${unbold}"
        npm -g install keybase-installer
    fi
    if [ ! $(which grunt 2>/dev/null) ]; then
        echo "\n${bold}Installing Grunt...${unbold}"
        npm -g install grunt-cli
    fi
    if [ ! $(which gulp 2>/dev/null) ]; then
        echo "\n${bold}Installing Gulp...${unbold}"
        npm -g install gulp
    fi
    if [ ! $(which yo 2>/dev/null) ]; then
        echo "\n${bold}Installing Yeoman...${unbold}"
        npm -g install yo
    fi
fi

# Ruby
if [ ! $(which mux 2>/dev/null) ]; then
    echo "\n${bold}Installing Tmuxinator...${unbold}"
    [ -e $HOME/Dropbox ] && ln -sF $HOME/Dropbox/.tmuxinator/ $HOME/.tmuxinator
    gem install tmuxinator
fi
if [ ! $(which bundle 2>/dev/null) ]; then
    echo "\n${bold}Installing Bundler...${unbold}"
    gem install bundler
fi
if [ ! $(which travis 2>/dev/null) ]; then
    echo "\n${bold}Installing Travis...${unbold}"
    gem install travis
fi

# Wordpress Coding Standards - http://joseph.is/1wdO6SC
if [ -d $HOME/.config/WordPress-Coding-Standards ]; then
    echo "\n${bold}Updating WordPress Coding Standards...${unbold}"
    cd $HOME/.config/WordPress-Coding-Standards; git pull
else
    echo "\n${bold}Installing WordPress Coding Standards...${unbold}"
    git clone -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git \
        $HOME/.config/WordPress-Coding-Standards
    echo "\n${bold}Adding WordPress to PHP Code Sniffer Standards...${unbold}"
    $HOME/.composer/vendor/bin/phpcs --config-set installed_paths $HOME/.config/WordPress-Coding-Standards
    $HOME/.composer/vendor/bin/phpcs -i
fi

# Vim - http://joseph.is/1sZma4R
if [ -d $HOME/.vim/bundle/Vundle.vim ]; then
    echo "\n${bold}Updating Vundle...${unbold}"
    cd $HOME/.vim/bundle/Vundle.vim; git pull
else
    echo "\n${bold}Installing Vundle...${unbold}"
    git clone https://github.com/gmarik/Vundle.vim.git $HOME/.vim/bundle/Vundle.vim
fi
echo "\n${bold}Installing/updating Vundle Plugins...${unbold}"
vim -u $HOME/.vimrc.bundles +PluginInstall +PluginClean! +qa

echo "\nDone."

