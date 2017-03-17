# oh-my-zsh settings
path=(
    .git/safe/../../bin
    .git/safe/../../node_modules/.bin
    .git/safe/../../vendor/bin
    ~/.bin
    ~/.composer/vendor/bin
    ~/go/bin
    /usr/local/heroku/bin
    /usr/local/MacGPG2/bin
    /usr/local/share/npm/bin
    /usr/local/bin
    /usr/local/sbin
    /usr/bin
    /usr/sbin
    /bin
    /sbin
)

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# golang
export GOPATH=$HOME/go

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true

# oh my zsh
export ZSH=$HOME/.zsh
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT="true"
ZSH_THEME="robbyrussell"
plugins=(
    aws
    #brew
    #brew-cask
    #bundler
    colored-man-pages
    #colorize
    #docker
    #docker-compose
    #fabric
    #gem
    #go
    # heroku
    #npm
    nvm
    #osx
    #pip
    #pyenv
    #python
    #rbenv
    #tmux
    tmuxinator
    virtualenvwrapper
    z
    #zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# load custom executable functions
for function_file in $ZSH/functions/*; do
    source $function_file
done
unset function_file

# Base16 shell theme
source $HOME/.config/base16-shell/base16-shell.plugin.zsh

# ls colors - joseph.is/1vozPB8
export LS_COLORS='di=1;36:ln=35:so=32:ex=31:bd=34:cd=34'

# grc beautifies all the things
source /usr/local/etc/grc.bashrc

# keybindings
bindkey \^U backward-kill-line

# hub alias
eval "$(hub alias -s)"

# aliases
[ -s ~/.aliases ] && source ~/.aliases

# local config
[ -s ~/.zshrc.local ] && source ~/.zshrc.local
