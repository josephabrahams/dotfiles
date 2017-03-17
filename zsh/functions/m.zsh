# tries to start mux with session called current dir name
# if doesn't exist, runs `mux list`

m() {

    project_list() {
        tmuxinator list | grep -v "tmuxinator projects"
    }

    git rev-parse --show-toplevel > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        local dirname=$(basename $(git rev-parse --show-toplevel))
    else
        local dirname=$(basename $(pwd))
    fi

    dirname=$(echo $dirname | sed 's/^\.//' | sed 's/\./\-/g')

    if [[ -z "$1" ]]; then
        if [[ -f "$HOME/.tmuxinator/${dirname}.yml" ]]; then
            echo "Using $dirname"
            tmuxinator start $(basename $dirname)
        else
            echo "$dirname not found"
            project_list
        fi
    elif [[ "$1" == "list" || "$1" == "ls" ]]; then
        project_list
    elif [[ "$1" == "new" || "$1" == "open" ]]; then
        if [[ -z "$2" ]]; then
            echo "Using $dirname"
            tmuxinator new $dirname
        else
            echo "Using $@"
            tmuxinator $@
        fi
    elif [[ "$1" == "kill" ]]; then
        if [[ -z "$2" ]]; then
            echo "Killing $dirname"
            tmux kill-session -t $dirname
        else
            echo "Killing $2"
            tmux kill-session -t $2
        fi
    else
        # loop through all tmuxinator projects
        # start mux if matching 1st arg
        for muxfile in $(project_list); do
            if [[ "$1" == "$muxfile" ]]; then
                tmuxinator start $muxfile
                return 0
            fi
        done

        project_list
        return 1
    fi
}

# TODO: create completion function
# compdef m=mux
