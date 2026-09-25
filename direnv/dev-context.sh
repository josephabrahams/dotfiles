# shellcheck shell=bash
# ======================================================================
# Dev contexts for direnv
#
# Linked to ~/.config/direnv/lib/, which direnv sources before every
# .envrc. An org folder's .envrc selects a context with one line:
#
#     dev_context <name> <code|cursor>
#
# No .envrc means personal: default editor, default ~/.claude.
# See docs/CONTEXTS.md.
# ======================================================================

dev_context() {
    local name="${1:-}" editor="${2:-}" data_dir

    # Validate before exporting anything: direnv applies whatever was
    # exported even when the .envrc fails, so a bad call must not leave a
    # half-set context behind. DEV_CONTEXT_ERROR makes c refuse to launch.
    if (($# != 2)) || [[ ! $name =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
        export DEV_CONTEXT_ERROR="dev_context: usage: dev_context <name> <code|cursor> (name: lowercase, digits, dashes)"
        log_error "$DEV_CONTEXT_ERROR"
        return 1
    fi
    case $editor in
        code) data_dir="$HOME/.vscode-$name" ;;
        cursor) data_dir="$HOME/.cursor-$name" ;;
        *)
            export DEV_CONTEXT_ERROR="dev_context: unsupported editor '$editor' (code or cursor)"
            log_error "$DEV_CONTEXT_ERROR"
            return 1
            ;;
    esac

    export WORK_CONTEXT="$name"
    export DEV_EDITOR="$editor"
    export EDITOR_USER_DATA_DIR="$data_dir"
    export CLAUDE_CONFIG_DIR="$HOME/.claude-$name"

    # An API key in the environment beats subscription login in Claude Code
    unset ANTHROPIC_API_KEY

    if [[ ! -d $EDITOR_USER_DATA_DIR || ! -d $CLAUDE_CONFIG_DIR ]]; then
        log_error "dev_context: '$name' is not set up yet, run dev-context-init"
    fi
}
