complete_on_all() {
    local names=$(s list | grep "^$1")
    COMPREPLY=( $names )
}


commands() {
    local commands='help completion status start stop restart'
    for command in $(echo $commands); do
        echo $command
    done
}


_s_completion() {
    local cur prev words cword
    _init_completion || return

    local command=${COMP_WORDS[1]}

    case $command in
        status|\
        start|\
        stop|\
        restart)
            complete_on_all $cur
            return
            ;;
    esac

    matching_commands="$(commands | grep "^$cur")"
    if [ -n "$matching_commands" ]; then
        COMPREPLY=( $matching_commands )
    fi
}


main() {
    complete -F _s_completion s
}


main "$@"
