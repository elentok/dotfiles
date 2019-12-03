export DOTF=~/.dotfiles
export DOTL=~/.dotlocal

# Identify OS {{{1
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

# Identify Linux Distro {{{1
export DISTRO=''
if is_linux; then
  if [[ "$HOME" =~ termux ]]; then
    export DISTRO=termux
  elif [ -f /etc/arch-release ]; then
    export DISTRO=arch
  elif [[ "$(cat /proc/version)" =~ "fedora" ]]; then
    export DISTRO=fedora
  else
    export DISTRO=debian
  fi
fi

is_arch() {
  [ "$DISTRO" = "arch" ]
}

is_termux() {
  [ "$DISTRO" = "termux" ]
}

is_debian() {
  [ "$DISTRO" = "debian" ]
}

is_fedora() {
  [ "$DISTRO" = "fedora" ]
}

# Identify WSL {{{1
export IS_WSL=no

if is_linux; then
  if ! is_termux; then
    if [[ "$(cat /proc/version)" =~ 'Microsoft' ]]; then
      export IS_WSL=yes
    fi
  fi
fi

is_wsl() {
  [ "$IS_WSL" = "yes" ]
}

# Shell {{{1
function is_zsh() {
  [ -n "$ZSH_VERSION" ]
}

function is_bash() {
  [ -n "$BASH_VERSION" ]
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


# TMP
export TMP=/tmp
if is_termux; then
  export TMP=$HOME/tmp
fi

# File owner
function file-owner() {
  if is-gnu-stat; then
    stat --format=%U "$*"
  else
    stat -f '%Su' "$*"
  fi
}

function is-gnu-stat() {
  if is_mac; then
    [[ "$(which stat)" =~ /gnubin/ ]]
  else
    return 0
  fi
}

# Disable <Ctrl-s> lock on interactive shells {{{1
# see:
# * https://stackoverflow.com/questions/24623021
# * https://unix.stackexchange.com/questions/72086
# * https://unix.stackexchange.com/questions/26676
[[ $- == *i* ]] && stty -ixon

# Homebrew {{{1
BREW_HOME=''
for dir in ~/.linuxbrew ~/.homebrew /usr/local; do
  if [ -e "$dir/bin/brew" ]; then
    export BREW_HOME=$dir
    break
  fi
done

if [ -e "$BREW_HOME" ]; then
  if [ -e "$BREW_HOME/Homebrew" ]; then
    export BREW_ROOT="$BREW_HOME/Homebrew"
  else
    export BREW_ROOT="$BREW_HOME"
  fi
fi

# NodeJS {{{1
export N_PREFIX=$HOME/.n

# Go {{{1
if [ -e $HOME/.apps/go ]; then
  export GOROOT=$HOME/.apps/go
else
  export GOROOT=$BREW_HOME/opt/go/libexec
fi
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
PATH="$DOTF/scripts:\
$DOTL/scripts:\
$HOME/.yarn/bin:\
$N_PREFIX/bin:\
$HOME/.fzf/bin:\
$HOME/bin:\
$HOME/scripts:\
$HOME/.local/bin"

if is_termux; then
  PATH=$PATH:/data/data/com.termux/files/usr/bin:/data/data/com.termux/files/usr/bin/applets
fi

if [ -n "$BREW_HOME" ]; then
  PATH=$PATH:$BREW_HOME/bin:$BREW_HOME/sbin:$BREW_HOME/opt/coreutils/libexec/gnubin
fi

[ -n "$GOROOT" ] && PATH=$PATH:$GOROOT/bin:$MAIN_GOPATH/bin
for ver in 3.6 3.7; do
  [ -d $HOME/Library/Python/$ver/bin ] && PATH=$PATH:$HOME/Library/Python/$ver/bin
done

# replace bsd binaries with gnu
for pkg in coreutils findutils gnu-sed; do
  gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
  if [ -e "$gnubin" ]; then
    PATH=$PATH:$gnubin
  fi
done

PATH="$PATH:\
$HOME/.cargo/bin:\
$HOME/.rbenv/bin:\
$HOME/.rbenv/shims:\
/snap/bin:\
/usr/local/share/npm/bin:\
/usr/local/bin:\
/usr/local/sbin:\
/usr/bin:\
/bin:\
/usr/sbin:\
/sbin"

if [ -e /usr/lib/cinnamon-settings-daemon ]; then
  PATH=$PATH:/usr/lib/cinnamon-settings-daemon
fi

if is_wsl; then
  PATH=$PATH:/mnt/c/Windows:/mnt/c/Windows/System32:/mnt/c/Windows/System32/WindowsPowerShell/v1.0
fi

export PATH


# EDITOR {{{1

# TODO: figure this out
if [ -n "${NVIM_LISTEN_ADDRESS:-}" ]; then
  export EDITOR='nvr -cc split --remote-wait'
elif [ ! -z "${VSCODE_IPC_HOOK:-}" ]; then
  # Use vscode as the editor for things like Git when run from within vscode's
  # integrated terminal
	export EDITOR="code -w"
elif has_command nvim; then
  export EDITOR=$(which nvim)
else
  export EDITOR=vim
fi

export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# TMUX {{{1
# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" && "$TERM" != "tmux" ]]; then
  export TERM=xterm-256color
fi

export TMUX_TMPDIR="$TMP/$(whoami)"
mkdir -p $TMUX_TMPDIR

# Neovim Terminal {{{1
is_in_neovim() {
  [ -n "${NVIM_LISTEN_ADDRESS:-}" ]
}

# MISC {{{1
export SSH_TERM=xterm-color
export LESS="--RAW-CONTROL-CHARS"
export RIPGREP_CONFIG_PATH="$DOTF/plugins/ripgrep/ripgreprc"

if is_mac; then
  export JAVA_HOME="$(/usr/libexec/java_home 2> /dev/null)"
fi

# DOTLOCAL {{{1
source_if_exists "$DOTL/zsh/core.zsh"
source_if_exists "$DOTL/zsh/core.sh"

# vim: foldmethod=marker
