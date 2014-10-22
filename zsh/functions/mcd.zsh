# make a directory and then change into it

function mcd() {
    if [ -z "$1" ]; then
        echo "mcd: missing operand"
        return 1
    fi

    mkdir $1
    cd $1
}
