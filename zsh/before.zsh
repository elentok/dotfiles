# Android {{{1
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/build-tools/23.0.0

# Completions {{{1
fpath=($BREW_HOME/lib/node_modules/tailr/completions $fpath)
fpath=(/usr/local/share/npm/lib/node_modules/tailr/completions $fpath)
fpath=(/usr/local/share/npm/lib/node_modules/dns-switcher/completions $fpath)
fpath=($HOME/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/shaft-0.8.8/completions $fpath)

# Go {{{1
if [ -e $BREW_HOME/Cellar/go/default/libexec ]; then
  export GOROOT=$BREW_HOME/Cellar/go/default/libexec
else
  export GOROOT=$BREW_HOME/Cellar/go/default
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

# vim: foldmethod=marker
