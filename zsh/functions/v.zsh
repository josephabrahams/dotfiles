# `v` with no arguments opens the current directory in Vim
# otherwise opens the given location
# http://joseph.is/1yOpjYV

v() {
    if [ $# -eq 0 ]; then
        vim +NERDTreeToggle
    else
        vim "$@"
    fi
}
