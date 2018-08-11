# oh-my-zsh settings
if [[ -o login ]]; then
    path=(
        ~/.bin
        ~/.composer/vendor/bin
        ~/go/bin
        /Library/TeX/texbin
        /usr/local/opt/python/libexec/bin
        /usr/local/bin
        /usr/local/sbin
        /usr/bin
        /usr/sbin
        /bin
        /sbin
    )
fi

# locale
export LANG="en_US.UTF-8"

# use vim as the visual editor
export VISUAL="vim"
export EDITOR="vim"

# golang
export GOPATH="$HOME/go"

# pip should only run if there is a virtualenv currently activated
export PIP_REQUIRE_VIRTUALENV=true
export PIPENV_DONT_LOAD_ENV=true
export PIPENV_SHELL_FANCY=true
export PIPENV_VENV_IN_PROJECT=true

# oh my zsh
export ZSH="$HOME/.zsh"
COMPLETION_WAITING_DOTS=true
DISABLE_UPDATE_PROMPT=true
ZSH_THEME="bureau"
plugins=(
    # aws
    # catimg
    chucknorris
    colored-man-pages
    # docker
    # docker-compose
    # docker-machine
    # ember-cli
    # gem
    github
    gitignore
    # gnu-utils
    # golang
    heroku
    history-substring-search
    iterm2
    marked2
    # nmap
    # node
    # npm
    nvm
    osx
    # pyenv
    # python
    # redis-cli
    safe-paste
    # tmux
    tmuxinator
    # wp-cli
    # vi-mode
    vundle
    z
)
source $ZSH/oh-my-zsh.sh

nvm_prompt_info() {
    if [ -n "$NVM_BIN" ]; then
        echo "${ZSH_THEME_NVM_PROMPT_PREFIX}$(basename $(dirname $NVM_BIN))${ZSH_THEME_NVM_PROMPT_SUFFIX} "
    fi
}
pipenv_prompt_info() {
    if [ -n "$VIRTUAL_ENV" ]; then
        echo "($(basename $WORKON_HOME)) "
    fi
}
RPROMPT='$(nvm_prompt_info)$(pipenv_prompt_info)$(bureau_git_prompt)'

# load custom executable functions
for function_file in $ZSH/functions/*; do
    source $function_file
done
unset function_file

# Base16 shell theme
BASE16_SHELL=$HOME/.config/base16-shell/
[ -n "$PS1" ] && [ -s $BASE16_SHELL/profile_helper.sh ] && eval "$($BASE16_SHELL/profile_helper.sh)"

# ls colors - joseph.is/1vozPB8
export LS_COLORS="di=1;36:ln=35:so=32:ex=31:bd=34:cd=34"

# grc beautifies all the things
source /usr/local/etc/grc.bashrc

# keybindings
bindkey \^U backward-kill-line
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# pipenv completion
eval "$(pipenv --completion)"

# aliases
[ -s ~/.aliases ] && source ~/.aliases

# local config
[ -s ~/.zshrc.local ] && source ~/.zshrc.local

# [ -z "$TMUX" ] && [ -z "$PIPENV_ACTIVE" ] && chuck_cow
