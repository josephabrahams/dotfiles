# `v` with no arguments opens the current directory in Vim
# otherwise opens the given location

function v() {
    if [ $# -eq 0 ]; then
        vim .
    else
        vim "$@"
    fi
}
