# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# enable programmable completion features
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi

if [[ $(which brew) && -f $(brew --prefix)/share/bash-completion/bash_completion ]]; then
	. $(brew --prefix)/share/bash-completion/bash_completion
fi


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

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# ------------------------------------------
# Custom Tab Completion
# ------------------------------------------

. <(npm completion)
. "$HOME/.bash/.git-completion.bash"
. "$HOME/.scm_breeze/scm_breeze.sh"


# ------------------------------------------
# Aliases & Functions
# ------------------------------------------


# reference: apt-get suggestions are from "command_not_found_handle"

# borrow bash complete functions for my own aliases
# to see existing complete function names: `complete -p <command>`
# http://ubuntuforums.org/showthread.php?t=733397
borrow_completion() {
	local borrower_function_name="$1"
	local borrowed_function_name="$2"
	local arg_count=$(($#-3))
	shift 2
	local gen_function_name="__borrowed_${borrowed_function_name}_FOR_${borrower_function_name}"
	local args="$*"
	local gen_function="
		$gen_function_name () {
			COMP_LINE=\"$@\${COMP_LINE#$borrower_function_name}\"
			let COMP_POINT+=$((${#args}-${#borrower_function_name}))
			((COMP_CWORD+=$arg_count))
			COMP_WORDS=( "$@" \${COMP_WORDS[@]:1} )
			"$borrowed_function_name"
			return 0
		}"
	eval "$gen_function"
	#echo "$gen_function"
	complete -F $gen_function_name $borrower_function_name
}

if [ -x /usr/bin/atop ]; then
	alias top='atop'
fi

alias homesick="$HOME/.homeshick"
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alFhv'
alias wget='wget -c' # resume wget by default

if man --no-hyphenation --no-justification man &>/dev/null; then
	alias man='man --no-hyphenation --no-justification';
fi


# package managers
if [ $(which yum) ]; then
	pms() {
		sudo yum search all --showduplicates --debuglevel=0 --errorlevel=0 "$1"
		echo ''
		sudo yum list --showduplicates --debuglevel=0 --errorlevel=0 "$1"
	}
	# less wraps lines improperly because of input buffering.
	#pmsl() { unbuffer bash -cis 'pms $0' "$1" |& less -R; }
	pmsl() { unbuffer bash -cis 'pms $0' "$1" | less -R; }
	pmf() {
		echo 'Installed Package Matches'
		echo '-------------------------'
		rpm -qa | grep "$1"
		echo ''
		echo 'Package Info'
		echo '------------'
		sudo yum info --debuglevel=0 --errorlevel=0 "$1"
		echo ''
		echo "Installed Files"
		echo '---------------'
		rpm -ql "$1"
	}
	#pmfl() { unbuffer bash -cis 'pmf $0' "$1" |& less -R; }
	pmfl() { unbuffer bash -cis 'pmf $0' "$1" | less -R; }
	alias pmi='sudo yum install'
	alias pmu='sudo yum update'
	alias pmr='sudo yum remove'
elif [ $(which apt-get) ]; then
	pms() {
		echo 'Partial Matches'
		echo '-------------------------'
		sudo apt-cache search "$1"
		echo ''
		echo 'Exact Matches (with version info)'
		echo '-------------------------'
		sudo apt-cache show "$1" | grep -e '^Package:' -e '^Section:' -e '^Version:' -e '^$'
	}
	borrow_completion pms _apt_cache apt-cache show

	pmf() {
		echo 'Installed Package Matches:'
		echo '-------------------------'
		dpkg -l | grep -i "$1"
		echo ''
		echo 'Package Info:'
		echo '------------'
		apt-cache show "$1"
		echo ''
		echo "Installed Files:"
		echo '---------------'
		dpkg-query -L "$1"
	}
	borrow_completion pmf _apt_cache apt-cache show

	alias pmi='sudo apt-get install'
	borrow_completion pmi _apt_get apt-get install

	alias pmu='sudo apt-get update && sudo apt-get upgrade'

	alias pmr='sudo apt-get remove'
	borrow_completion pmr _apt_get apt-get remove
elif [ $(which brew) ]; then
	pms() {
		echo 'Partial Matches'
		echo '-------------------------'
		brew search "$1"
		echo ''
		echo 'Description Matches'
		echo '-------------------------'
		brew desc -s "$1"
		echo ''
		echo 'Exact Matches (with version info)'
		echo '-------------------------'
		brew info "$1"
	}
	pmf() {
		echo 'Package Info:'
		echo '------------'
		brew info "$1"
		echo ''
		echo "Installed Files:"
		echo '---------------'
		brew list "$1"
	}
	alias pmi='brew install'
	alias pmu='brew update && brew upgrade'
	alias pmr='brew uninstall'
fi


dirstat() {
	dir="$1"
	if [[ -z $dir ]]; then
		dir="."
	fi
	find "$dir" -mindepth 1 -maxdepth 1 -print0 | xargs -0 du -shc | sort -h | tac
}


gitt() {
	echo "test";
}

_gitt_complete() {
	local cur prev words cword split
	_init_completion -s ||  return
	COMPREPLY=( $( compgen -W "zship/amd zship/deferreds" -- "$cur" ) )
}

complete -F _gitt_complete gitt


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
