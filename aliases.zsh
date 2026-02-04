# ======================================================================
# Navigation & Directory Shortcuts
# ======================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias b='cd -'

alias d='cd ~/Desktop'
alias dl='cd ~/Downloads'
alias dots='cd ~/.dotfiles'
alias dr='cd ~/Dropbox'
alias p='cd ~/Projects'

# ======================================================================
# File & Directory Listing (eza)
# ======================================================================

alias ls='eza --icons --group-directories-first --color=always'
alias l='ls -A --classify=auto'
alias ll='ls -al --classify=auto'
alias lt='ls --tree --level=2'
alias lss='grc --colour=auto /bin/ls' # Fallback to system ls

# ======================================================================
# File Operations
# ======================================================================

alias ln='ln -iv'
alias mv='mv -i'

# ======================================================================
# Search & Filtering
# ======================================================================

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias map='xargs -n1' # Map function: find . -name .gitattributes | map dirname

# ======================================================================
# Git
# ======================================================================

# Status & info
alias g='git status'
alias glg='git log'
alias gt='git tree'
alias gd='git diff'
alias gds='git diff --staged'

# Branching
alias gb='git branch'
alias gbd='git branch -D'
alias gs='git switch'
alias gsc='git switch -c'

# Staging
alias ga='git add'
alias gaa='git add -A'
alias gr='git restore'
alias grs='git restore --staged'

# Committing
alias gc='git commit'
alias gcm='git commit -m'
alias gca='git commit --amend --no-edit'
alias gcac='git commit --amend'
alias gcam='git commit --amend -m'

# Syncing
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpu='git push -u origin $(git branch --show-current)'

# Rewriting history
alias grb='git rebase'
alias grbi='git rebase -i'
alias grb2='git rebase -i HEAD~2'

# Completions
compdef _git glg=git-log gt=git-log
compdef _git gd=git-diff gds=git-diff
compdef _git gb=git-branch gbd=git-branch
compdef _git gs=git-switch gsc=git-switch
compdef _git ga=git-add gaa=git-add
compdef _git gr=git-restore grs=git-restore
compdef _git gc=git-commit gcm=git-commit gca=git-commit gcac=git-commit gcam=git-commit
compdef _git gl=git-pull
compdef _git gp=git-push gpf=git-push gpu=git-push
compdef _git grb=git-rebase grbi=git-rebase grb2=git-rebase
_wt() { compadd $(git branch --format='%(refname:short)' 2>/dev/null) }
compdef _wt wt

# ======================================================================
# Development Tools
# ======================================================================

alias fs='foreman start'
alias fr='foreman run'
alias fm='foreman run python manage.py'
alias nvm='fnm'

# ======================================================================
# System & Shell
# ======================================================================

alias sudo='sudo ' # Enable aliases to be sudo'ed
alias reload="exec ${SHELL} -l"
alias reload!="rm -rf ~/.config/zsh/completions && reload"
alias path='echo -e ${PATH//:/\\n}'
alias top='htop'
alias week='date +%V'

# ======================================================================
# Networking & DNS
# ======================================================================

alias ip='curl checkip.amazonaws.com'
alias localip='ipconfig getifaddr en0'
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"
alias jcurl='curl -H "Content-Type: application/json"'

# ======================================================================
# Data & Text Processing
# ======================================================================

alias copy="tr -d '\n' | pbcopy"
alias trim="sed 's/^[[:space:]]*//;s/[[:space:]]*$//'"
alias json='jq . -C'

# ======================================================================
# macOS Specific
# ======================================================================

alias hidedesktop='defaults write com.apple.finder CreateDesktop -bool false && killall Finder'
alias showdesktop='defaults write com.apple.finder CreateDesktop -bool true && killall Finder'
alias pubkey='cat ~/.ssh/id_ed25519.pub'
