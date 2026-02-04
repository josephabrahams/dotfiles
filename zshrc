# ======================================================================
# Environment Setup
# ======================================================================

# Custom scripts
export PATH="$HOME/bin:$PATH"

# Add Homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=1

# Add PostgreSQL 18 to path
export PATH="/opt/homebrew/opt/postgresql@18/bin:$PATH"

# Zsh config
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS          # Don't save duplicate commands
setopt HIST_IGNORE_SPACE         # Don't save commands starting with space
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt INC_APPEND_HISTORY        # Write to history immediately (don't wait for shell exit)

# Node config
export NODE_REPL_HISTORY=~/.node_history;
export NODE_REPL_HISTORY_SIZE=10000;
export NODE_REPL_MODE="sloppy";
eval "$(fnm env --use-on-cd)"

# Python config
export PIP_REQUIRE_VIRTUALENV=1
export PIPENV_DONT_LOAD_ENV=1
export PIPENV_SHELL_FANCY=1
export PIPENV_VENV_IN_PROJECT=1
export PIPENV_VERBOSITY=-1

# Editors
export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LESS="-R"  # Preserve ANSI color codes in less

# GPG - required for commit signing and terminal passphrase prompts
export GPG_TTY=$(tty)

# AWS - load config from ~/.aws/config
export AWS_SDK_LOAD_CONFIG=1

# Colorize common commands
export GRC_ALIASES=true
[[ -s "$(brew --prefix)/etc/grc.zsh" ]] && source "$(brew --prefix)/etc/grc.zsh"

# Smarter cd
eval "$(zoxide init zsh)"

# ======================================================================
# Plugin Manager (Antidote)
# ======================================================================

source "$(brew --prefix antidote)/share/antidote/antidote.zsh"

# Build the Antidote bundle if it doesn't exist or plugins.txt changed
if [[ ! -f $ZDOTDIR/plugins.zsh ]] || [[ $ZDOTDIR/plugins.txt -nt $ZDOTDIR/plugins.zsh ]]; then
    echo "Building Antidote bundle..."
    antidote bundle < $ZDOTDIR/plugins.txt >| $ZDOTDIR/plugins.zsh
fi
source $ZDOTDIR/plugins.zsh

# ======================================================================
# Completions
# ======================================================================

fpath=("$(brew --prefix)/share/zsh/site-functions" $fpath)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select                    # Arrow key navigation
zstyle ':completion:*' list-prompt ''                 # No pager prompt
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'   # Case-insensitive matches
zstyle ':completion:*' list-colors 'di=34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43'
zstyle ':completion:*' use-cache on
zstyle ':completion:*:make:*' tag-order targets       # Only show Makefile targets
LISTMAX=0                                             # Never ask "show all N?"
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete    # Shift+Tab to go back
# Cached completions (regenerate with: reload!)
COMP_DIR=~/.config/zsh/completions
[[ -d $COMP_DIR ]] || mkdir -p $COMP_DIR
[[ -f $COMP_DIR/_npm ]] && source $COMP_DIR/_npm || { npm completion > $COMP_DIR/_npm && source $COMP_DIR/_npm }
[[ -f $COMP_DIR/_fly ]] && source $COMP_DIR/_fly || { fly completion zsh > $COMP_DIR/_fly 2>/dev/null && source $COMP_DIR/_fly }
[[ -f $COMP_DIR/_uv ]]  && source $COMP_DIR/_uv  || { uv generate-shell-completion zsh > $COMP_DIR/_uv 2>/dev/null && source $COMP_DIR/_uv }
# Docker completions (symlink to Homebrew site-functions if needed)
if [[ ! -L $(brew --prefix)/share/zsh/site-functions/_docker ]] && [[ -d /Applications/Docker.app ]]; then
    ln -sf /Applications/Docker.app/Contents/Resources/etc/docker.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker
    ln -sf /Applications/Docker.app/Contents/Resources/etc/docker-compose.zsh-completion $(brew --prefix)/share/zsh/site-functions/_docker-compose
fi

# ======================================================================
# Load Config Files
# ======================================================================

for file in $ZDOTDIR/*.zsh; do
    [[ $file == */plugins.zsh ]] && continue
    source "$file"
done

# ======================================================================
# Interactive Features
# ======================================================================

# Starship prompt
eval "$(starship init zsh)"

# fzf key bindings and completion
eval "$(fzf --zsh)"

# Ensure emacs mode
bindkey -e

# History search - filter by prefix matching
bindkey '^[[A' history-beginning-search-backward  # Up arrow
bindkey '^[[B' history-beginning-search-forward   # Down arrow

# Fix forward delete key
bindkey '^[[3~' delete-char

# ======================================================================
# Local Customizations
# ======================================================================

[[ -f ~/.config/zsh/.zshrc.local ]] && source ~/.config/zsh/.zshrc.local
