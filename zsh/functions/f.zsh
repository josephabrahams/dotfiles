# case insensitive search of the current directory subtree
# for files with names containing a string - joseph.is/1sLgmai

function f() {
    if [ -z "$1" ]; then
        echo "find: missing operand"
        return 1
    fi

    find . -iname "*$1*" ${@:2}
}
