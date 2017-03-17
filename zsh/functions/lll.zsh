# `lll` runs `ll` and pipes the output to less

function lll() {
    gls -alF --color=always "$@" | less -R
}

# `lLl` follows symlinks

function lLl() {
    gls -alLF --color=always "$@" | less -R
}
