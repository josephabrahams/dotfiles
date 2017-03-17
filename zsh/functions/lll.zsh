# `lll` runs `ll` and pipes the output to less
lll() {
    CLICOLOR_FORCE=1 ls -alFG "$@" | less -R
}

# `llll` follows symlinks
llll() {
    CLICOLOR_FORCE=1 ls -alLFG "$@" | less -R
}
