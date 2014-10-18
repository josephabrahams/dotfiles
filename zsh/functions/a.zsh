# searches the current directory subtree for
# files containing a string (ignores case)
a() {
    if [ -z "$1" ]; then
        echo "ag: missing operand"
        return 1
    fi

    ag "$1" ${@:2} -i --color-match="" .
}
