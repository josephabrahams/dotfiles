# No arguments: `psysh`
# With arguments: acts like `php`

function php() {
    if [[ $# > 0 ]]; then
        /usr/local/bin/php $@
    else
        psysh
    fi
}

