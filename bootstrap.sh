#!/bin/sh
# install/upgrade all the things

bold='\033[1m'
unbold='\033[0m'

# Homebrew - http://joseph.is/1DCbIBY
echo "\n${bold}Updating Homebrew formulas...${unbold}"
brew update
echo "\n${bold}Upgrading installed brews...${unbold}"
brew upgrade
echo "\n${bold}Remove unneeded brews...${unbold}"
brew cleanup

# Zsh Syntax Highlighting - http://joseph.is/1yPtYtq
if [ -d $HOME/.zsh/custom/plugins/zsh-syntax-highlighting ]; then
    echo "\n${bold}Updating Zsh Syntax Highlighting...${unbold}";
    cd $HOME/.zsh/custom/plugins/zsh-syntax-highlighting; git pull
else
    echo "\n${bold}Installing Zsh Syntax Highlighting...${unbold}";
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
        $HOME/.zsh/custom/plugins/zsh-syntax-highlighting
fi

# Base16 color scheme - http://joseph.is/11RoQHA
if [ -d $HOME/.config/base16-iterm2 ]; then
    echo "\n${bold}Updating Base16 iTerm2 color scheme...${unbold}";
    cd $HOME/.config/base16-iterm2; git pull
else
    echo "\n${bold}Installing Base16 iTerm2 color scheme...${unbold}";
    git clone https://github.com/chriskempson/base16-iterm2.git $HOME/.config/base16-iterm2
fi
if [ -d $HOME/.config/base16-shell ]; then
    echo "\n${bold}Updating Base16 shell color scheme...${unbold}";
    cd $HOME/.config/base16-shell; git pull
else
    echo "\n${bold}Installing Base16 shell color scheme...${unbold}";
    git clone https://github.com/chriskempson/base16-shell.git $HOME/.config/base16-shell
fi

# JavaScript - http://joseph.is/1p6nO5g
if [ $(which npm) ]; then
    echo "\n${bold}Updating NPM...${unbold}";
    npm -g update
    if [ ! $(which jshint) ]; then
        echo "\n${bold}Installing JSHint...${unbold}";
        npm -g install jshint
    fi
    if [ ! $(which grunt) ]; then
        echo "\n${bold}Installing Grunt...${unbold}";
        npm -g install grunt-cli
    fi
    if [ ! $(which gulp) ]; then
        echo "\n${bold}Installing Gulp...${unbold}";
        npm -g install gulp
    fi
fi

# PHP - http://joseph.is/1tTzucL
if [ ! $(which composer) ]; then
    echo "\n${bold}Installing Composer...${unbold}";
    curl -sS https://getcomposer.org/installer | php
    mv composer.phar /usr/local/bin/composer
    echo "\n${bold}Installing Global Composer Packages...${unbold}";
    composer global install
else
    echo "\n${bold}Updating Composer...${unbold}";
    composer self-update
    echo "\n${bold}Updating Global Composer Packages...${unbold}";
    composer global update
fi

# Wordpress Coding Standards - http://joseph.is/1wdO6SC
if [ -d $HOME/.config/WordPress-Coding-Standards ]; then
    echo "\n${bold}Updating WordPress Coding Standards...${unbold}";
    cd $HOME/.config/WordPress-Coding-Standards; git pull
else
    echo "\n${bold}Installing WordPress Coding Standards...${unbold}";
    git clone -b master https://github.com/WordPress-Coding-Standards/WordPress-Coding-Standards.git \
        $HOME/.config/WordPress-Coding-Standards
    echo "\n${bold}Adding WordPress to PHP Code Sniffer Standards...${unbold}";
    $HOME/.composer/vendor/bin/phpcs --config-set installed_paths $HOME/.config/WordPress-Coding-Standards
    $HOME/.composer/vendor/bin/phpcs -i
fi

echo "\nDone."

