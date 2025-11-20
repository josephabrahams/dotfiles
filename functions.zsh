# ======================================================================
# File & Directory Navigation
# ======================================================================

# Create a new directory and enter it
mkd() {
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
# File & Directory Operations
# ======================================================================

# Reminder to use rg instead of ag
ag() {
    echo "use rg instead"
    return 1
}

# Case insensitive search for files by name
f() {
    if [ -z "$1" ]; then
        echo "find: missing operand"
        return 1
    fi
    find . -iname "*$1*" ${@:2}
}

# Determine size of a file or total size of a directory
fsize() {
    if du -b /dev/null >/dev/null 2>&1; then
        local arg=-sbh
    else
        local arg=-sh
    fi
    if [[ -n "$@" ]]; then
        du $arg -- "$@"
    else
        du $arg .[^.]* ./*
    fi
}

# Create a .tar.gz archive, using `zopfli`, `pigz` or `gzip` for compression
targz() {
    local tmpFile="${@%/}.tar"
    tar -cvf "${tmpFile}" --exclude=".DS_Store" "${@}" || return 1

    # Get file size (try macOS stat, then GNU stat)
    size=$(
        stat -f"%z" "${tmpFile}" 2>/dev/null ||
            stat -c"%s" "${tmpFile}" 2>/dev/null
    )

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

    echo "Compressing .tar ($((size / 1000)) kB) using \`${cmd}\`…"
    "${cmd}" -v "${tmpFile}" || return 1
    [ -f "${tmpFile}" ] && rm "${tmpFile}"

    # Get compressed file size (try macOS stat, then GNU stat)
    zippedSize=$(
        stat -f"%z" "${tmpFile}.gz" 2>/dev/null ||
            stat -c"%s" "${tmpFile}.gz" 2>/dev/null
    )

    echo "${tmpFile}.gz ($((zippedSize / 1000)) kB) created successfully."
}

# ======================================================================
# Development Tools
# ======================================================================

# Load .env file into shell session for environment variables
envup() {
    if [ ! -s .env ]; then
        echo 'No .env file found' 1>&2
        return 1
    fi
    export $(cat .env)
}

# Start an HTTP server from a directory, optionally specifying the port
server() {
    local port="${1:-8000}"
    sleep 1 && open "http://localhost:${port}/" &
    # Set the default Content-Type to `text/plain` instead of `application/octet-stream`
    python3 -c "import http.server; h = http.server.SimpleHTTPRequestHandler; h.extensions_map[''] = 'text/plain'; http.server.test(HandlerClass=h, port=$port)"
}

# ======================================================================
# Git
# ======================================================================

# Use Git's colored diff when available
if hash git &>/dev/null; then
    diff() {
        git diff --no-index --color-words "$@"
    }
fi

# GitHub CLI wrapper
gh() {
    if [ $# -eq 0 ]; then
        command gh repo view -wb $(git branch --show-current)
    else
        command gh "$@"
    fi
}
