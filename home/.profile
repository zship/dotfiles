if [[ ! $ORIG_PATH ]]; then
    export ORIG_PATH="$PATH"
fi

if [[ ! $ORIG_MANPATH ]]; then
    export ORIG_MANPATH="$MANPATH"
fi

next_path=''
next_manpath=''

add_if_new() {
    # append $2 if $1 doesn't already contain $2
    if ! echo "$1" | tr ':' '\n' | grep "^$2$" &> /dev/null; then
        echo "$1:$2" | sed 's/^://'
    else
        echo "$1"
    fi
}

add_manpath() {
    if [ ! -d "$1" ]; then
        return
    fi

    next_manpath="$(add_if_new "$next_manpath" "$1")"
}

add_path() {
    if [ ! -d "$1" ]; then
        return
    fi

    next_path="$(add_if_new "$next_path" "$1")"

    if [ -d "$2" ]; then
        add_manpath "$2"
    fi
}

add_default_path() {
    IFS=':'

    local prev_path="$ORIG_PATH"
    local prev_manpath="$ORIG_MANPATH"

    for p in $prev_path; do
        add_path "$p"
    done

    # `manpath` only uses man's heuristics if MANPATH is empty
    export MANPATH=""
    default_manpath="$(manpath)"

    for p in $prev_manpath; do
        add_manpath "$p"
    done

    for p in $default_manpath; do
        add_manpath "$p"
    done

    IFS=$' \n\t'
}

main() {
    add_path "$HOME/bin"
    add_path "/usr/local/opt/coreutils/libexec/gnubin" "/usr/local/opt/coreutils/libexec/gnuman"
    add_path "/usr/local/git/bin"
    add_path "/usr/local/bin" "/usr/local/share/man"
    add_path "/usr/local/sbin"
    add_default_path
    add_path "/bin"
    add_path "/sbin"
    add_path "/usr/bin"
    add_path "/usr/sbin"
    add_path "/usr/local/ant/bin"
    add_path "$HOME/.cabal/bin" "$HOME/.cabal/share/man"
    add_path "/usr/local/share/npm/bin" "/usr/local/share/npm/share/man"
    add_path "$HOME/Downloads/git-tf-2.0.2.20130214"
    add_path "$HOME/android-sdk-linux/tools"
    add_path "$HOME/android-sdk-linux/platform-tools"
    add_path "$HOME/adt-bundle-mac-x86_64/sdk/tools"
    add_path "$HOME/adt-bundle-mac-x86_64/sdk/platform-tools"
    add_path "$HOME/Downloads/libimobiledevice-macosx"

    export PATH="$next_path"
    export MANPATH="$next_manpath"

    export DYLD_LIBRARY_PATH=/Users/zachshipley/Downloads/libimobiledevice-macosx/:$DYLD_LIBRARY_PATH

    export CLASSPATH=/usr/java/jdk/lib/rt.jar:/usr/java/jdk/lib/tools.jar

    if [ -f "$HOME/.config/brew" ]; then
        export HOMEBREW_GITHUB_API_TOKEN="$(cat $HOME/.config/brew)"
    fi
}

main
