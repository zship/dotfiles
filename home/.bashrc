# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# enable programmable completion features
if [ -f /etc/bash_completion ]; then
	. /etc/bash_completion
fi



# ------------------------------------------
# General Settings
# ------------------------------------------

export EDITOR='vim'

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# ------------------------------------------
# Environment Variables
# ------------------------------------------

PATH=$PATH:$HOME/bin/:/usr/local/ant/bin/:/sbin/:$HOME/.cabal/bin/:/usr/local/share/npm/bin
CLASSPATH=/usr/java/jdk/lib/rt.jar:/usr/java/jdk/lib/tools.jar:
#export JAVA_HOME=/etc/alternatives/java_sdk/

adbpath=''
if [ -e $HOME/android-sdk-linux ]; then
	adbpath="$HOME/android-sdk-linux"
elif [ -e $HOME/adt-bundle-mac-x86_64/sdk ]; then
	adbpath="$HOME/adt-bundle-mac-x86_64"
fi
PATH=$PATH:$adbpath/platform-tools:$adbpath/tools


# ------------------------------------------
# Custom Tab Completion
# ------------------------------------------

eval "$(grunt --completion=bash)"
source ~/.git-completion.bash


# ------------------------------------------
# Aliases & Functions
# ------------------------------------------

# homesick is a dotfile sync program: https://github.com/andsens/homeshick
if [ -f "$HOME/.homeshick" ]; then
	alias homesick="$HOME/.homeshick"
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

if [ -x /usr/bin/atop ]; then
	alias top='atop'
fi

alias ll='ls -alFh'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# resume wget by default
alias wget='wget -c'


# package managers
if [ -x /usr/bin/yum ]; then
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
elif [ -x /usr/bin/apt-get ]; then
	pms() {
		echo 'Partial Matches'
		echo '-------------------------'
		echo ''
		sudo apt-cache search "$1"
		echo 'Exact Matches (with version info)'
		echo '-------------------------'
		sudo apt-cache show "$1" | grep -e '^Package:' -e '^Section:' -e '^Version:' -e '^$'
	}
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
	alias pmi='sudo apt-get install'
	alias pmu='sudo apt-get update && sudo apt-get upgrade'
	alias pmr='sudo apt-get remove'
elif [ -x /usr/local/bin/brew ]; then
	pms() {
		echo 'Partial Matches'
		echo '-------------------------'
		echo ''
		brew search "$1"
		echo 'Description Matches'
		echo '-------------------------'
		echo ''
		brew desc -s "$1"
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
		brew list --unbrewed "$1"
	}
	alias pmi='brew install'
	alias pmu='brew update && brew upgrade'
	alias pmr='brew uninstall'
fi


# universal archive extraction
extract() {
	filename=$1
	# extract to a directory named "file [minus] extension"
	filename="./${filename%.*}"
	wrapper_dir="$filename"
	count=0

	# directory exists? keep incrementing count and adding it to the end of the name
    while [ -d "$wrapper_dir" ]; do
		let "count += 1"
		wrapper_dir="${filename}.${count}"
		#echo "$wrapper_dir"
	done

	7z x "$1" -o"$wrapper_dir" &>/dev/null

	# check wrapper_dir contents for just one folder; move contents up one dir and remove the single dir
	dirs=$(find "$wrapper_dir" -mindepth 1 -maxdepth 1 -type d | wc -l)
	files=$(find "$wrapper_dir" -mindepth 1 -maxdepth 1 -type f | wc -l)
	if [ "$dirs" == '1' ] && [ "$files" == '0' ]; then
		inner_dir=$(find "$wrapper_dir" -mindepth 1 -maxdepth 1 -type d)
		find "$inner_dir" -mindepth 1 -maxdepth 1 | xargs mv -iv -t "$wrapper_dir" &>/dev/null
		rmdir "$inner_dir"
	fi

	curpath=$(pwd)
	echo "$curpath/$(basename $1) => $curpath/$(basename $wrapper_dir)/"
}


#netinfo - shows network information for your system
netinfo() {
	echo "--------------- Network Information ---------------"
	/sbin/ifconfig | awk /'inet addr/ {print $2}'
	/sbin/ifconfig | awk /'Bcast/ {print $3}'
	/sbin/ifconfig | awk /'inet addr/ {print $4}'
	/sbin/ifconfig | awk /'HWaddr/ {print $4,$5}'
	myip=`lynx -dump -hiddenlinks=ignore -nolist http://checkip.dyndns.org:8245/ | sed '/^$/d; s/^[ ]*//g; s/[ ]*$//g' `
	echo "${myip}"
	echo "---------------------------------------------------"
}


#dirsize - finds directory sizes and lists them for the current directory
dirstat() {
	du -shx * .[a-zA-Z0-9_]* 2> /dev/null | \
	egrep '^ *[0-9.]*[MG]' | sort -n > /tmp/list
	egrep '^ *[0-9.]*M' /tmp/list
	egrep '^ *[0-9.]*G' /tmp/list
	rm -rf /tmp/list
}
