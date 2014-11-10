# all the paths
path=(
    .git/safe/../../bin
    ~/.bin
    ~/.composer/vendor/bin
    # ~/.rbenv/shims
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

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
# cache pip-installed packages to avoid re-downloading
export PIP_DOWNLOAD_CACHE=$HOME/.pip/cache

# load rbenv if available
if which rbenv &>/dev/null; then
    eval "$(rbenv init - zsh --no-rehash)"
fi

# local config
[ -s ~/.zshenv.local ] && source ~/.zshenv.local
