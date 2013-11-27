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
    . "$HOME/bin/shlacker"
    . "$HOME/bin/.git-completion.bash"
    hash brew && . $(brew --prefix)/share/bash-completion/bash_completion
    hash npm && . <(npm completion)
    . <(p completion)
    . /usr/share/doc/tmux/examples/bash_completion_tmux.sh
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
alias ll='shlacker --format file ls --color=always -alFhv'
alias less='less -RXSF'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias wget='wget -c' # resume wget by default

alias gs='shlacker --format file --pty git status'
alias gc='git commit'
alias gb='git blame'
alias gd='git diff'
alias gl='git lg'

ga() {
    git add "$@"; gs
}

alias se='shlacker-expand'
alias sf='shlacker --format file'

if man --no-hyphenation --no-justification man &> /dev/null; then
    alias man='man --no-hyphenation --no-justification'
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

# For non-OS X systems, a placeholder for the program from
# https://github.com/ChrisJohnsen/tmux-MacOSX-pasteboard
reattach-to-user-namespace() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        command reattach-to-user-namespace "$@"
    else
        exec "$@"
    fi
}


# alias core git commands by wrapping git
my_git() {
    args="${@:2}"
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
        lg)
            PAGER='less -RXSF' shlacker --format sha --pty command git log --graph --pretty=format:'%C(yellow)%h%C(reset) - %C(bold)%an%C(reset) %C(bold cyan)%ai (%ar)%C(reset)%C(red)%d%C(reset)%n''              %s' "$args"
            ;;
        *)
            shlacker command git "$@"
            ;;
    esac
}

alias git="my_git"
__git_complete my_git __git_main
