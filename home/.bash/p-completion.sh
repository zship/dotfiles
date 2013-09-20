complete_on_installed() {
    local pkg_manager="$P_COMPLETION_PKG_MANAGER"
    local names

    if [ $pkg_manager == 'apt' ]; then
        names=$(dpkg-query -l "$1*" | grep '^ii' | perl -pe 's/^ii +(\S*) +.*/\1/g')
    elif [ $pkg_manager == 'brew' ]; then
        names=$(brew list | grep "^$1")
    elif [ $pkg_manager == 'yum' ]; then
        names=$(yum list installed | grep "^$1" | perl -pe 's/^(.*)\s+.*/\1/g')
    fi

    COMPREPLY=( $names )
}


complete_on_all() {
    local pkg_manager="$P_COMPLETION_PKG_MANAGER"
    local names

    if [ $pkg_manager == 'apt' ]; then
        names=$(dpkg-query --show --showformat='${Package}\n' "$1*")
    elif [ $pkg_manager == 'brew' ]; then
        names=$(find "$(brew --prefix)/Library/Formula" -name '*.rb' | perl -pe 's/.*\/(.*).rb$/\1/' | grep "^$1")
    elif [ $pkg_manager == 'yum' ]; then
        names=$(yum list | grep "^$1" | perl -pe 's/^(.*)\s+.*/\1/g')
    fi

    COMPREPLY=( $names )
}


_p_completion() {
    local cur prev words cword
    _init_completion || return

    local command=${COMP_WORDS[1]}

    case $command in
        remove|\
        installed|\
        files|\
        upgrade|\
        purge)
            complete_on_installed $cur
            return
            ;;
        search|\
        info|\
        deplist|\
        install|\
        reinstall|\
        whatprovides)
            complete_on_all $cur
            return
            ;;
        update|\
        outdated|\
        clean|\
        autoclean)
            return
            ;;
    esac

    matching_commands="$(p commands | grep "^${COMP_WORDS[1]}")"
    if [ -n "$matching_commands" ]; then
        COMPREPLY=( $matching_commands )
    fi
}


main() {
    if which apt-get &>/dev/null; then
        export P_COMPLETION_PKG_MANAGER='apt'
    elif which brew &>/dev/null; then
        export P_COMPLETION_PKG_MANAGER='brew'
    elif which yum &>/dev/null; then
        export P_COMPLETION_PKG_MANAGER='yum'
    fi

    complete -F _p_completion p
}


main "$@"
