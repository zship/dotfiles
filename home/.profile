PATH=$PATH:$HOME/bin/
PATH=$PATH:/usr/local/ant/bin/
PATH=$PATH:/sbin/
PATH=$PATH:$HOME/.cabal/bin/
PATH=$PATH:/usr/local/share/npm/bin

adbpath=''
if [ -e $HOME/android-sdk-linux ]; then
	adbpath="$HOME/android-sdk-linux"
elif [ -e $HOME/adt-bundle-mac-x86_64/sdk ]; then
	adbpath="$HOME/adt-bundle-mac-x86_64/sdk"
fi
PATH=$PATH:$adbpath/platform-tools:$adbpath/tools

CLASSPATH=/usr/java/jdk/lib/rt.jar:/usr/java/jdk/lib/tools.jar:
export NODE_PATH=/usr/local/lib/jsctags/:$NODE_PATH
