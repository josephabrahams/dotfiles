# searches the current directory subtree for
# files with names containing a string (ignores case)
f() {
    if [ -z "$1" ]; then
        echo "find: missing operand"
        return 1
    fi

    find . -iname "*$1*" ${@:2}
}
