# No arguments: `git status`
# With arguments: acts like `git`
# http://joseph.is/1oujSLs

function g() {
    if [[ $# > 0 ]]; then
        git $@
    else
        git status
    fi
}

# Complete g like git
compdef g=git
