# ======================================================================
# Navigation & Directory Shortcuts
# ======================================================================

alias ..='cd ..'
alias ...='cd ../..'
alias b='cd -'

alias d='cd ~/Desktop'
alias dl='cd ~/Downloads'
alias dots='cd ~/.dotfiles'
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
alias gcam='git commit --amend'

# Syncing
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease --force-if-includes'
alias gpu='git push -u origin $(git branch --show-current)'

# Rewriting history
alias grb='git rebase'
alias grbi='git rebase -i'
alias grb2='git rebase -i HEAD~2'

# ======================================================================
# Development Tools
# ======================================================================

alias fs='foreman start'
alias fr='foreman run'
alias fm='foreman run python manage.py'

# ======================================================================
# System & Shell
# ======================================================================

alias sudo='sudo ' # Enable aliases to be sudo'ed
alias reload="exec ${SHELL} -l"
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
alias digga='dig +short'
alias ptr='dig ptr +short'

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
