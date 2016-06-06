export DOTF=~/.dotfiles
export DOTL=~/.dotlocal

# OS {{{1
if [ "`uname -s`" = "Darwin" ]; then
  export OS=mac
else
  export OS=linux
fi

is_mac() {
  [ "$OS" = "mac" ]
}
is_linux() {
  [ "$OS" = "linux" ]
}

# Helper functions {{{1
source_if_exists() {
  if [ -e "$1" ]; then source $1; fi
}

CACHED_EVAL_ROOT="$HOME/.cache/dotfiles"

cached_eval() {
  local cache_key="$1"
  local cache_file="$CACHED_EVAL_ROOT/$cache_key"
  shift

  mkdir -p "$CACHED_EVAL_ROOT"

  if [ ! -e "$cache_file" ]; then
    "$@" > "$cache_file"
  fi

  source "$cache_file"
}

# Check if command exists {{{1
has_command() {
  type "$1" > /dev/null 2>&1
}

command_missing() {
  ! has_command "$1"
}

# Check if process is running {{{1
is_running() {
  ps cax | grep "$1" > /dev/null 2>&1
}

# Identify Linux Distro {{{1
if is_linux; then
  if has_command pacman; then
    export DISTRO=arch
  else
    export DISTRO=debian
  fi
fi

is_arch() {
  [ "$DISTRO" = "arch" ]
}

is_debian() {
  [ "$DISTRO" = "debian" ]
}


# BREW_HOME {{{1
for dir in ~/.linuxbrew ~/.homebrew /usr/local; do
  if [ -e "$dir" ]; then
    export BREW_HOME=$dir
    break
  fi
done

# Go {{{1
export GOROOT=$BREW_HOME/opt/go/libexec
export MAIN_GOPATH=$HOME/go
export GOPATH=$MAIN_GOPATH
export GO15VENDOREXPERIMENT=1

if [ -d "$BREW_HOME/share/app-engine-go-64/goroot" ]; then
  export GOPATH=$GOPATH:$BREW_HOME/share/app-engine-go-64/goroot
fi

if is_mac; then
  export CGO_CPPFLAGS="-I $BREW_HOME/include"
  export CGO_LDFLAGS="-L $BREW_HOME/lib"
fi

# PATH {{{1
PATH=$DOTF/scripts:$DOTL/scripts
PATH=$PATH:$BREW_HOME/bin
PATH=$PATH:$HOME/.fzf/bin
PATH=$PATH:$HOME/bin:$HOME/scripts:$HOME/.local/bin
PATH=$PATH:$GOROOT/bin:$MAIN_GOPATH/bin

# replace bsd binaries with gnu
for pkg in coreutils findutils gnu-sed; do
  gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
  if [ -e "$gnubin" ]; then
    PATH=$PATH:$gnubin
  fi
done

PATH=$PATH:$HOME/.rbenv/shims
PATH=$PATH:/usr/local/share/npm/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

export PATH

# EDITOR {{{1
if has_command nvim; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# TMUX {{{1
# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" ]]; then
  export TERM=xterm-256color
fi

export TMUX_TMPDIR=/tmp/$USERNAME
mkdir -p $TMUX_TMPDIR

# LOCALE {{{1
# required for bundler to work correctly
# without these it throws "ArgumentError: invalid byte sequence in US-ASCII"
# whenever it finds a gemspec with non-unicode characters
# (see http://ruckus.tumblr.com/post/18613786601/bundler-install-error-argumenterror-invalid-byte)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# DOTLOCAL {{{1
if [ -e "$DOTL/zsh/core.zsh" ]; then
  source "$DOTL/zsh/core.zsh"
fi

# MISC {{{1
export SSH_TERM=xterm-color

if is_mac; then
  export JAVA_HOME="$(/usr/libexec/java_home)"
fi

# vim: foldmethod=marker
