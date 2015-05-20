# all the paths
path=(
    .git/safe/../../bin
    ~/.bin
    ~/.composer/vendor/bin
    ~/go/bin
    /usr/local/bin
    /usr/local/heroku/bin
    /usr/local/MacGPG2/bin
    # /usr/local/opt/coreutils/libexec/gnubin
    /usr/local/sbin
    /usr/local/share/npm/bin
    /usr/bin
    /usr/sbin
    /bin
    /sbin
)
# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# use vim as the visual editor
export VISUAL=vim
export EDITOR=$VISUAL

# have Boto use AWS CLI config
export BOTO_CONFIG="$HOME/.aws/config"

# Brew Cask install path
export HOMEBREW_CASK_OPTS="--appdir=/Applications"

# golang
export GOPATH=$HOME/go

# nvm
export NVM_DIR=$HOME/.nvm

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# load pyenv if available
if which pyenv > /dev/null; then
    eval "$(pyenv init -)"
fi
if which pyenv-virtualenv-init > /dev/null; then
    eval "$(pyenv virtualenv-init -)";
fi

# load rbenv if available
if which rbenv > /dev/null; then
    eval "$(rbenv init - zsh --no-rehash)"
fi

# load nvm if available
[ -s $(brew --prefix nvm)/nvm.sh ] && source $(brew --prefix nvm)/nvm.sh

# local config
[ -s ~/.zshenv.local ] && source ~/.zshenv.local
