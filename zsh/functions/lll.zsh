# `lll` runs `ll` and pipes the output to less

function lll() {
    ll | less -R
}
