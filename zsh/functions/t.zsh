# `t` is a shorthand for `tree` with hidden files and color enabled, listing directories first.
# The output gets piped into `less` with options to preserve color and line numbers,
# unless the output is small enough for one screen.
# http://joseph.is/1yOpjYV

function t() {
    tree -aC -I '.DS_Store|.Trash|.bundle|.git|.sass-cache|bower_components|node_modules' --dirsfirst "$@" | less -FR
}
