# colorize the prompt
PS1="\u@\h:\[\e[1;36m\]\w\[\e[0m\]\\$ "

# colorize `ls`
if ls --color > /dev/null 2>&1; then
    # GNU
    export LS_COLORS="di=1;36:ln=35:so=32:ex=31:bd=34:cd=34"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'
else
    # BSD
    export LSCOLORS="Gxfxcxdxbxegedabagacad"
    alias ls='ls -G'
fi

# colorize `grep`
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# aliases
alias ..="cd .."
alias l="ls -AF"
alias ll="ls -alF"
