# oh-my-zsh settings
export ZSH=$HOME/.zsh
COMPLETION_WAITING_DOTS="true"
DISABLE_UPDATE_PROMPT="true"
ZSH_THEME="robbyrussell"
plugins=(
    bower
    bundler
    brew
    colored-man
    fabric
    gem
    npm
    osx
    pip
    python
    rbenv
    tmux
    tmuxinator
    vagrant
    virtualenvwrapper
    z
    zsh-syntax-highlighting
)
source $ZSH/oh-my-zsh.sh

# load custom executable functions
for function_file in $ZSH/functions/*; do
    source $function_file
done
unset function_file

# Base16 shell theme
if [[ "${TERM#*256}" != "$TERM" ]]; then
    BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
    [ -s $BASE16_SHELL ] && source $BASE16_SHELL
fi

# ls colors - joseph.is/1vozPB8
export LS_COLORS='di=1;36:ln=35:so=32:ex=31:bd=34:cd=34'

# grc beautifies all the things
[ $+commands[grc] ] && [ $+commands[brew] ] && source /usr/local/etc/grc.bashrc

# more autocompletion scripts
eval "$(grunt --completion=zsh)"
eval "$(gulp --completion=zsh)"
if which aws_zsh_completer.sh &>/dev/null; then
    source `which aws_zsh_completer.sh`
fi
[ -s ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# keybindings
bindkey \^U backward-kill-line

# aliases
[ -s ~/.aliases ] && source ~/.aliases

# local config
[ -s ~/.zshrc.local ] && source ~/.zshrc.local
