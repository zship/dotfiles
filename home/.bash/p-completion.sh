cached_function_name() {
    local fn=$(eval printf "\$P_COMPLETION_FOR_$1" 2>/dev/null)
    if [ -z "$fn" ]; then
        fn=$(complete -p "$1" | perl -pe "s/.* -F (.*) $1/\1/")
        export "P_COMPLETION_FOR_$1"
        eval "P_COMPLETION_FOR_$1=$fn"
    fi
    printf "$fn"
}


borrow() {
    local from="$1"
    local to="$2"

    char_difference=$(( $(printf "$to" | wc -m) - $(printf "$from" | wc -m) ))
    let COMP_POINT+=$char_difference

    word_difference=$(( $(printf "$to" | wc -w) - $(printf "$from" | wc -w) ))
    let COMP_CWORD+=$word_difference

    COMP_LINE=$( printf "$COMP_LINE" | sed "s/$from/$to/" )
    COMP_WORDS=( $COMP_LINE )

    local cmd=${COMP_WORDS[0]}
    local fn=$(cached_function_name "$cmd")
    "$fn"
}


_p_completion() {
    local pkg_manager="$P_COMPLETION_PKG_MANAGER"
    local command=${COMP_WORDS[1]}

    if [ $pkg_manager == 'apt' ]; then

        case $command in
            update)
                borrow 'p update' 'apt-get update'
                return
                ;;
            outdated)
                borrow 'p outdated' 'apt-get upgrade'
                return
                ;;
            installed)
                borrow 'p installed' 'dpkg'
                return
                ;;
            files)
                borrow 'p files' 'dpkg-query -L'
                return
                ;;
            search)
                borrow 'p search' 'apt-cache search'
                return
                ;;
            info)
                borrow 'p info' 'apt-cache show'
                return
                ;;
            deplist)
                borrow 'p deplist' 'apt-cache depends'
                return
                ;;
            install)
                borrow 'p install' 'apt-get install'
                return
                ;;
            reinstall)
                borrow 'p reinstall' 'apt-get install --reinstall'
                return
                ;;
            upgrade)
                borrow 'p upgrade' 'apt-get upgrade'
                return
                ;;
            remove)
                borrow 'p remove' 'apt-get remove'
                return
                ;;
            purge)
                borrow 'p purge' 'apt-get remove'
                return
                ;;
            clean)
                borrow 'p clean' 'apt-get clean'
                return
                ;;
            autoclean)
                borrow 'p autoclean' 'apt-get autoclean'
                return
                ;;
        esac

    elif [ $pkg_manager == 'brew' ]; then

        case $command in
            update)
                borrow 'p update' 'brew update'
                return
                ;;
            outdated)
                borrow 'p outdated' 'brew outdated'
                return
                ;;
            installed)
                ;;
            files)
                borrow 'p files' 'brew list'
                return
                ;;
            search)
                borrow 'p search' 'brew search'
                return
                ;;
            info)
                borrow 'p info' 'brew info'
                return
                ;;
            deplist)
                borrow 'p deplist' 'brew deps'
                return
                ;;
            install)
                borrow 'p install' 'brew install'
                return
                ;;
            reinstall)
                ;;
            upgrade)
                borrow 'p upgrade' 'brew upgrade'
                return
                ;;
            remove)
                borrow 'p remove' 'brew remove'
                return
                ;;
            purge)
                ;;
            clean)
                ;;
            autoclean)
                borrow 'p autoclean' 'brew cleanup'
                return
                ;;
        esac

    elif [ $pkg_manager == 'yum' ]; then

        case $command in
            update)
                borrow 'p update' 'yum check-update'
                return
                ;;
            outdated)
                borrow 'p outdated' 'yum check-update'
                return
                ;;
            installed)
                borrow 'p installed' 'rpm -qa'
                return
                ;;
            files)
                borrow 'p files' 'rpm -ql'
                return
                ;;
            search)
                borrow 'p search' 'yum search'
                return
                ;;
            info)
                borrow 'p info' 'yum info'
                return
                ;;
            deplist)
                borrow 'p deplist' 'yum deplist'
                return
                ;;
            install)
                borrow 'p install' 'yum install'
                return
                ;;
            reinstall)
                borrow 'p reinstall' 'yum reinstall'
                return
                ;;
            upgrade)
                borrow 'p upgrade' 'yum update'
                return
                ;;
            remove)
                borrow 'p remove' 'yum erase'
                return
                ;;
            purge)
                ;;
            clean)
                borrow 'p clean' 'yum clean'
                return
                ;;
            autoclean)
                borrow 'p autoclean' 'yum clean'
                return
                ;;
        esac

    fi

    matching_commands="$(p commands | grep "^${COMP_WORDS[1]}")"
    if [ -n "$matching_commands" ]; then
        COMPREPLY=( $matching_commands )
    fi

    #echo "$COMP_LINE" >> ~/comp-test
    #echo "$COMP_POINT" >> ~/comp-test
    #echo "$COMP_CWORD" >> ~/comp-test
    #echo "${COMP_WORDS[@]}" >> ~/comp-test
}

complete -F _p_completion p


if [ $(which apt-get) ]; then
    export P_COMPLETION_PKG_MANAGER='apt'
elif [ $(which brew) ]; then
    export P_COMPLETION_PKG_MANAGER='brew'
elif [ $(which yum) ]; then
    export P_COMPLETION_PKG_MANAGER='yum'
fi
