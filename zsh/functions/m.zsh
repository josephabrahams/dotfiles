# tries to start mux with session called current dir name
# if doesn't exist, runs `mux list`

function m() {
    local dirname=$(basename $(pwd) | sed 's/\./\-/g')

    if [[ -z "$1" ]]; then
        if [[ -f "$HOME/.tmuxinator/${dirname}.yml" ]]; then
            mux start $(basename $dirname)
        else
            mux list
        fi
    elif [[ "$1" == "list" || "$1" == "ls" ]]; then
        mux list
    elif [[ "$1" == "new" || "$1" == "open" ]]; then
        if [[ -z "$2" ]]; then
            mux new $dirname
        else
            mux $@
        fi
    elif [[ "$1" == "kill" ]]; then
        tmux kill-session -t $2
    else
        for muxfile in $(mux list | grep -v "tmuxinator projects"); do
            if [[ "$1" == "$muxfile" ]]; then
                mux start $muxfile
                return 0
            fi
        done

        mux list
        return 1
    fi
}

# TODO: create completion function
compdef m=mux
