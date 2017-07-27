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

DOTF_CACHE_ROOT="$HOME/.cache/dotfiles"

with_cache() {
  local cache_key="$1"
  local cache_command="$2"
  local cache_file="$DOTF_CACHE_ROOT/$cache_key"
  shift
  shift

  mkdir -p "$DOTF_CACHE_ROOT"

  if [ ! -e "$cache_file" ]; then
    "$@" > "$cache_file"
  fi

  $cache_command "$cache_file"
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
  if [ -d "$dir" ]; then
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

# Node {{{1
export NODE_MODULES="$(cd "$(dirname $(which node))/../lib/node_modules" && pwd)"

# PATH {{{1
PATH=$DOTF/scripts:$DOTL/scripts
PATH=$PATH:$HOME/.yarn/bin
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

PATH=$PATH:$HOME/.rbenv/bin:$HOME/.rbenv/shims
PATH=$PATH:/usr/local/share/npm/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

if [ -e /usr/lib/cinnamon-settings-daemon ]; then
  PATH=$PATH:/usr/lib/cinnamon-settings-daemon
fi

# yarn
if has_command yarn; then
  yarn_bin="$(with_cache yarn-global-bin cat yarn global bin)"
  PATH=$PATH:$yarn_bin
fi

export PATH

# EDITOR {{{1

# TODO: figure this out
# if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
  # export EDITOR='nvr -cc split --remote-wait'

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

# MISC {{{1
export SSH_TERM=xterm-color
export LESS="--RAW-CONTROL-CHARS"

if is_mac; then
  export JAVA_HOME="$(/usr/libexec/java_home 2> /dev/null)"
fi

# vim: foldmethod=marker
# Nix Package Manager {{{1
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  source $HOME/.nix-profile/etc/profile.d/nix.sh;
  export MANPATH=$HOME/.nix-profile/share/man:$MANPATH
fi

# DOTLOCAL {{{1
if [ -e "$DOTL/zsh/core.zsh" ]; then
  source "$DOTL/zsh/core.zsh"
fi

# Linux Specific {{{1
if is_linux; then
  # i3
  export XDG_CURRENT_DESKTOP=i3

  # So tmux sessions opened from ssh can access X11
  if [ -z "$DISPLAY" ]; then
    export DISPLAY=:0
  fi
fi

# vim: foldmethod=marker
