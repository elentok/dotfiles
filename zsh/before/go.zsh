if [ -e $BREW_HOME/Cellar/go/default/libexec ]; then
  export GOROOT=$BREW_HOME/Cellar/go/default/libexec
else
  export GOROOT=$BREW_HOME/Cellar/go/default
fi

export GOPATH=$HOME/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

alias ginpm="GOPATH=$PWD/.vendor gin"
