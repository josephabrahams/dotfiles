# ======================================================================
# Environment Setup
# ======================================================================

# Add Homebrew to path
eval "$(/opt/homebrew/bin/brew shellenv)"
export HOMEBREW_NO_ENV_HINTS=1

# Zsh config
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_DUPS          # Don't save duplicate commands
setopt HIST_IGNORE_SPACE         # Don't save commands starting with space
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt INC_APPEND_HISTORY        # Write to history immediately (don't wait for shell exit)

# Node config
export NVM_DIR="$HOME/.nvm"
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"
export NODE_REPL_HISTORY=~/.node_history;
export NODE_REPL_HISTORY_SIZE=10000;
export NODE_REPL_MODE="sloppy";

# Python config
export PIP_REQUIRE_VIRTUALENV=1
export PIPENV_DONT_LOAD_ENV=1
export PIPENV_SHELL_FANCY=1
export PIPENV_VENV_IN_PROJECT=1

# Editors
export EDITOR="vim"
export VISUAL="vim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export LESS="-R"  # Preserve ANSI color codes in less

# GPG - required for commit signing and terminal passphrase prompts
export GPG_TTY=$(tty)

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

# ======================================================================
# Load Config Files
# ======================================================================

for file in $ZDOTDIR/*.zsh; do
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
