# ======================================================================
# Navigation
# ======================================================================


# Create a new directory and enter it
mcd() {
    mkdir -p "$@" && cd "$_"
}

# Open directory or file in Finder
o() {
    if [ $# -eq 0 ]; then
        open .
    else
        open "$@"
    fi
}

# ======================================================================
# Search
# ======================================================================

# Search file contents and names for a pattern
ag() {
    if [ -z "$1" ]; then
        echo "usage: ag <pattern> [path...]" >&2
        return 1
    fi
    local pattern="$1"
    shift
    local paths=("${@:-.}")
    local content names

    content="$(rg -S --hidden --glob '!.git/**' --heading -n --color=always "$pattern" "${paths[@]}")"
    names="$(fd -Hs -E .git "$pattern" "${paths[@]}")"

    [[ -n "$content" ]] && print -r -- "$content"

    if [[ -n "$names" ]]; then
        [[ -n "$content" ]] && print
        print "\e[35mFilename & directory matches:\e[0m"
        print -r -- "$names" | rg --color=always "$pattern"
    fi
}

# Case insensitive search for files & directories by name
f() {
    if [ -z "$1" ]; then
        echo "usage: f <pattern> [path...]" >&2
        return 1
    fi
    fd -Hi "$@"
}

# ======================================================================
# Files
# ======================================================================

# Show size of file or directory (defaults to current dir)
fsize() {
    du -sh -- "${@:-.}"
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
    local name="${@%/}"
    [[ "$name" == "." ]] && name="${PWD##*/}"
    local tmpFile="${name}.tar"
    local tar_cmd=(tar -cf "${tmpFile}"
        --exclude=".DS_Store"
        --exclude=".git"
        --exclude="node_modules"
        --exclude=".venv"
        --exclude="venv"
        --exclude="__pycache__"
        --exclude="${tmpFile}"
        --exclude="${tmpFile}.gz"
        "${@}")
    if hash gum 2>/dev/null; then
        gum spin --spinner dot --title "Creating archive of ${name}…" -- "${tar_cmd[@]}" || return 1
    else
        echo "Creating archive of ${name}…"
        "${tar_cmd[@]}" || return 1
    fi

    size=$(wc -c <"${tmpFile}" | tr -d ' ')

    local cmd=""
    if ((size < 52428800)) && hash zopfli 2>/dev/null; then
        # the .tar file is smaller than 50 MB and Zopfli is available; use it
        cmd="zopfli"
    else
        if hash pigz 2>/dev/null; then
            cmd="pigz"
        else
            cmd="gzip"
        fi
    fi

    local compress_cmd=("${cmd}" "${tmpFile}")
    if hash gum 2>/dev/null; then
        gum spin --spinner dot --title "Compressing ${tmpFile} ($((size / 1000)) kB) using ${cmd}…" -- "${compress_cmd[@]}" || return 1
    else
        echo "Compressing ${tmpFile} ($((size / 1000)) kB) using \`${cmd}\`…"
        "${compress_cmd[@]}" || return 1
    fi
    [ -f "${tmpFile}" ] && rm "${tmpFile}"

    zippedSize=$(wc -c <"${tmpFile}.gz" | tr -d ' ')

    local ratio=$((100 - (zippedSize * 100 / size)))
    echo "${tmpFile}.gz created successfully ($((zippedSize / 1000)) kB, ${ratio}% reduction)"
}

# Word-by-word colored diff between two files
diff() {
    if [[ $# -ne 2 ]]; then
        echo "usage: diff <file1> <file2>" >&2
        return 1
    fi
    git diff --no-index --color-words "$@"
}

# ======================================================================
# Development
# ======================================================================

# Open current directory in Cursor
c() {
    local editor reuse_flag=""

    # Already inside an editor? Force reuse in that editor
    if [[ -n "${CURSOR_CLI:-}" ]]; then
        editor="cursor"
        reuse_flag="-r"
    elif [[ "$TERM_PROGRAM" == "vscode" ]]; then
        editor="code"
        reuse_flag="-r"
    else
        # Not inside any editor, pick based on availability
        if command -v cursor >/dev/null 2>&1; then
            editor="cursor"
        elif command -v code >/dev/null 2>&1; then
            editor="code"
        else
            echo "c: neither cursor nor vscode is installed" >&2
            return 127
        fi
    fi

    # Open files or project
    if [ "$#" -eq 0 ]; then
        if [[ -n "$reuse_flag" ]]; then
            echo "c: already in a workspace — pass a file or path to open" >&2
            return 1
        fi
        local -a workspaces=( *.code-workspace(N) )
        if (( ${#workspaces} == 1 )); then
            echo "c: opening workspace ${workspaces[1]}"
            command "$editor" "${workspaces[1]}"
        elif (( ${#workspaces} > 1 )); then
            echo "c: multiple .code-workspace files found: ${workspaces[*]}" >&2
            return 1
        else
            command "$editor" .
        fi
    else
        command "$editor" $reuse_flag "$@"
    fi
}

# Export .env variables into current shell
envup() {
    if [ ! -s .env ]; then
        echo 'No .env file found' 1>&2
        return 1
    fi
    export $(sed 's/#.*//; /^$/d' .env | xargs)
}

# GitHub CLI wrapper
gh() {
    _gh_check_error() {
        local err="$1"
        if [[ "$err" == *"SAML"* ]]; then
            echo "$err" >&2
            echo "Run: gh auth refresh -h github.com -s admin:org" >&2
            return 1
        elif [[ "$err" != *"no pull request"* && "$err" != *"Could not resolve"* ]]; then
            echo "$err" >&2
            return 1
        fi
        return 0
    }

    if [ $# -eq 0 ]; then
        local branch=$(git branch --show-current)
        local err
        if ! err=$(command gh pr view --web 2>&1); then
            if ! _gh_check_error "$err"; then
                return 1
            fi
            # No PR — open branch on GitHub if it exists on remote, otherwise open repo
            if git ls-remote --heads origin "$branch" | grep -q .; then
                if ! err=$(command gh repo view -wb "$branch" 2>&1); then
                    _gh_check_error "$err"
                    return $?
                fi
            else
                if ! err=$(command gh repo view -w 2>&1); then
                    _gh_check_error "$err"
                    return $?
                fi
            fi
        fi
    else
        command gh "$@"
    fi
}
compdef _gh gh

# Smart git switch (auto-switches when only one other branch exists)
gs() {
  if [ $# -eq 0 ]; then
    local branches=($(git branch --format='%(refname:short)' | grep -v "^$(git branch --show-current)$"))
    if [ ${#branches[@]} -eq 1 ]; then
      git switch "${branches[1]}"
    else
      git switch
    fi
  else
    git switch "$@"
  fi
}

# Open CI page (GitHub Actions or CircleCI)
ci() {
    local remote_url repo_path

    remote_url=$(git remote get-url origin 2>/dev/null)
    if [[ -z "$remote_url" ]]; then
        echo "Not a git repository or no origin remote" >&2
        return 1
    fi

    # Extract owner/repo from remote URL
    repo_path=$(echo "$remote_url" | sed -E 's#(git@|https://)([^:/]+)[:/]##' | sed 's/\.git$//')

    if [[ -d ".circleci" ]]; then
        open "https://app.circleci.com/pipelines/github/${repo_path}"
    elif [[ -d ".github/workflows" ]]; then
        open "https://github.com/${repo_path}/actions"
    else
        echo "No CI configuration found (.github/workflows or .circleci)" >&2
        return 1
    fi
}

# DNS lookup
digga() {
    if [ $# -gt 0 ]; then
        dig +short "$@"
    elif [ ! -t 0 ]; then
        xargs -n1 dig +short
    else
        echo "usage: digga <domain>..." >&2
        return 1
    fi
}

# Reverse DNS lookup
ptr() {
    if [ $# -gt 0 ]; then
        dig ptr +short "$@"
    elif [ ! -t 0 ]; then
        xargs -n1 dig ptr +short
    else
        echo "usage: ptr <ip>..." >&2
        return 1
    fi
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    python3 -c "import http.server; h = http.server.SimpleHTTPRequestHandler; h.extensions_map[''] = 'text/plain'; http.server.test(HandlerClass=h, port=$port)"
}
