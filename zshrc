# oh-my-zsh settings
export ZSH=$HOME/.zsh
ZSH_THEME="robbyrussell"
COMPLETION_WAITING_DOTS="true"
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
)
source $ZSH/oh-my-zsh.sh

# load custom executable functions
for function_file in $ZSH/functions/*; do
    source $function_file
done
unset function_file

# Base16 shell theme
BASE16_SHELL="$HOME/.config/base16-shell/base16-default.dark.sh"
[ -s $BASE16_SHELL ] && source $BASE16_SHELL

# ls colors - joseph.is/1vozPB8
export LS_COLORS='di=1;36:ln=35:so=32:ex=31:bd=34:cd=34'

# more autocompletion scripts
eval "$(grunt --completion=zsh)"
eval "$(gulp --completion=zsh)"
if which aws_zsh_completer.sh &>/dev/null; then
    source `which aws_zsh_completer.sh`
fi
[ -s ~/.travis/travis.sh ] && source ~/.travis/travis.sh

# aliases
[ -s ~/.aliases ] && source ~/.aliases

# local config
[ -s ~/.zshrc.local ] && source ~/.zshrc.local
