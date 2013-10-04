add_manpath() {
    if [ ! -d "$1" ]; then
        return
    fi

    if [ -n "$MANPATH" ]; then
        MANPATH="$MANPATH:$1"
    else
        MANPATH="$1"
    fi
}

add_path() {
    if [ ! -d "$1" ]; then
        return
    fi

    if [ -n "$PATH" ]; then
        PATH="$PATH:$1"
    else
        PATH="$1"
    fi

    if [ -d "$2" ]; then
        add_manpath "$2"
    fi
}

add_paths_from_file() {
    file="$1"
    if [ -f "$file" -a -r "$file" ]; then
        while read line; do
            add_path "$line"
        done < "$file"
    fi
}

add_default_paths() {
    if [ -f "/etc/environment" ]; then
        # Linux
        prev_path="$PATH"
        . /etc/environment
        if [ -n $prev_path ]; then
            PATH="$prev_path:$PATH"
        fi
    elif [ -f "/etc/paths" ]; then
        # OS X
        add_paths_from_file "/etc/paths"
        for file in /etc/paths.d/*; do
            add_paths_from_file "$file"
        done
    else
        # Cygwin
        add_path "/usr/local/bin"
        add_path "/usr/local/sbin"
        add_path "/usr/bin"
        add_path "/bin"
        add_path "/usr/sbin"
        add_path "/sbin"
    fi

    # `manpath` only uses man's heuristics if MANPATH is empty
    prev_manpath="$MANPATH"
    export MANPATH=""
    default_manpath=$(manpath)
    if [ -n $prev_manpath ]; then
        MANPATH="$prev_manpath:$default_manpath"
    else
        MANPATH="$default_manpath"
    fi
}
