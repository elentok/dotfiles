if [ -e /usr/local/Cellar/go/default/libexec ]; then
  export GOROOT=/usr/local/Cellar/go/default/libexec
else
  export GOROOT=/usr/local/Cellar/go/default
fi

export GOPATH=$HOME/.go-global
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
