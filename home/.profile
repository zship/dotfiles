. "$HOME/.bash/paths.sh"

export PATH=""
export MANPATH=""

add_path "/usr/local/opt/coreutils/libexec/gnubin" "/usr/local/opt/coreutils/libexec/gnuman"
add_path "/usr/local/git/bin"
add_path "/usr/local/bin" "/usr/local/share/man"
add_path "/usr/local/sbin"
add_default_paths
add_path "$HOME/bin"
add_path "$HOME/.bash"
add_path "/sbin"
add_path "/usr/local/ant/bin"
add_path "$HOME/.cabal/bin"
add_path "/usr/local/share/npm/bin" "/usr/local/share/npm/share/man"
add_path "$HOME/Downloads/git-tf-2.0.2.20130214"

add_path "$HOME/android-sdk-linux/tools"
add_path "$HOME/android-sdk-linux/platform-tools"
add_path "$HOME/adt-bundle-mac-x86_64/sdk/tools"
add_path "$HOME/adt-bundle-mac-x86_64/sdk/platform-tools"

add_path "$HOME/Downloads/libimobiledevice-macosx"
export DYLD_LIBRARY_PATH=/Users/zachshipley/Downloads/libimobiledevice-macosx/:$DYLD_LIBRARY_PATH

export CLASSPATH=/usr/java/jdk/lib/rt.jar:/usr/java/jdk/lib/tools.jar
export HOMEBREW_GITHUB_API_TOKEN="$(cat $HOME/.config/brew &> /dev/null)"
