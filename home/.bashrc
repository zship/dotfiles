# If not running interactively, don't do anything
[ -z "$PS1" ] &&  return

# ------------------------------------------
# General Settings
# ------------------------------------------

export EDITOR='vim'

shopt -s histappend # append to the history file, don't overwrite it

HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize
shopt -s globstar # make "**/*.ext" work
shopt -s dotglob  # include dotfiles in globbing

PS1="\[$(color bold green)\]\u@\h \[$(color blue)\]"'${PWD/#$HOME/~}'" \[$(color green)\]\$\[$(color off)\] "


# ------------------------------------------
# Custom Tab Completion
# ------------------------------------------

my_completions() {
    . /etc/bash_completion
    hash brew && . $(brew --prefix)/share/bash-completion/bash_completion
    hash npm && . <(npm completion)
    . <(p completion)
    . "$HOME/.bash/.git-completion.bash"
    . "$HOME/.scm_breeze/scm_breeze.sh"
}

my_completions &> /dev/null


# ------------------------------------------
# Aliases & Functions
# ------------------------------------------


# reference: apt-get suggestions are from "command_not_found_handle"

if hash atop &> /dev/null; then
    alias top='atop'
fi

alias homesick="$HOME/.homeshick"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alFhv'
alias wget='wget -c' # resume wget by default

if man --no-hyphenation --no-justification man &> /dev/null; then
    alias man='man --no-hyphenation --no-justification';
fi

tmux() {
    if [[ $# -gt 0 ]]; then
        command tmux "$@"
    else
        TERM=screen-256color command tmux attach || command tmux new
    fi
}

sshs() {
    ssh -t "$1" 'tmux attach || tmux new || screen -DR';
}


make() {
    makefile="$(findup Makefile)"
    pushd "$(dirname $makefile)" 1>/dev/null
    command make "$@"
    popd 1>/dev/null
}


# alias core git commands by wrapping git
my_git() {
    case "$1" in
        pull)
            git xpull "${@:2}"
            ;;
        push)
            git xpush "${@:2}"
            ;;
        stash)
            git xstash "${@:2}"
            ;;
        status)
            git xstatus "${@:2}"
            ;;
        *)
            command git "$@"
            ;;
    esac
}

alias git="my_git"
__git_complete my_git __git_main
