# case insensitive search of the current directory subtree
# for files containing a string using Ag - joseph.is/1sLgmai

function a() {
    if [ -z "$1" ]; then
        echo "ag: missing operand"
        return 1
    fi

    ag "$1" ${@:2} -i --color-match="" .
}
