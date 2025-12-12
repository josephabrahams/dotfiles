# ======================================================================
# Navigation
# ======================================================================

# Jump to directory
j() {
    # I always type `j dots` accidentally
    if [[ "$1" == "dots" ]]; then
        dots
    else
        z "$@"
    fi
}

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

    content="$(rg --hidden --glob '!.git/**' --heading -n --color=always "$pattern" "${paths[@]}")"
    names="$(fd -H "$pattern" "${paths[@]}")"

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

    size=$(stat -f"%z" "${tmpFile}")

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

    zippedSize=$(stat -f"%z" "${tmpFile}.gz")

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
    if [ $# -eq 0 ]; then
        command cursor .
    else
        command cursor "$@"
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
            # No PR, try repo view
            if ! err=$(command gh repo view -wb "$branch" 2>&1); then
                _gh_check_error "$err"
                return $?
            fi
        fi
    else
        command gh "$@"
    fi
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    python3 -c "import http.server; h = http.server.SimpleHTTPRequestHandler; h.extensions_map[''] = 'text/plain'; http.server.test(HandlerClass=h, port=$port)"
}
