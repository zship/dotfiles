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

export PATH=""
export MANPATH=""

add_path "/usr/local/opt/coreutils/libexec/gnubin" "/usr/local/opt/coreutils/libexec/gnuman"
add_path "/usr/local/git/bin"
add_path "/usr/local/bin" "/usr/local/share/man"
add_path "/usr/local/sbin"
add_default_paths
add_path "$HOME/bin"
add_path "$HOME/git-scripts"
add_path "/sbin"
add_path "/usr/local/ant/bin"
add_path "$HOME/.cabal/bin"
add_path "/usr/local/share/npm/bin"
add_path "$HOME/Downloads/git-tf-2.0.2.20130214"

add_path "$HOME/android-sdk-linux/tools"
add_path "$HOME/android-sdk-linux/platform-tools"
add_path "$HOME/adt-bundle-mac-x86_64/sdk/tools"
add_path "$HOME/adt-bundle-mac-x86_64/sdk/platform-tools"

add_path "$HOME/Downloads/libimobiledevice-macosx"
export DYLD_LIBRARY_PATH=/Users/zachshipley/Downloads/libimobiledevice-macosx/:$DYLD_LIBRARY_PATH

export CLASSPATH=/usr/java/jdk/lib/rt.jar:/usr/java/jdk/lib/tools.jar
export HOMEBREW_GITHUB_API_TOKEN="$(cat $HOME/.config/brew)"
