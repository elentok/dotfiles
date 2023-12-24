export DOTF=~/.dotfiles
export DOTL=~/.dotlocal
export DOTP=~/.dotprivate

# if dotf-is-core-loaded &> /dev/null; then
#   return
# fi
#
# function dotf-is-core-loaded() {
#   return
# }

# Helper: Source If Exists {{{1
source_if_exists() {
  if [ -e "$1" ]; then source "$1"; fi
}

# Load Configuration {{{1
source "$DOTF/core/zsh/config.sh"
source_if_exists "$DOTL/zsh/config.sh"
source_if_exists "$DOTP/zsh/config.sh"

source "$DOTF/core/scripts/lib/os.sh"
source "$DOTF/core/scripts/lib/helpers.sh"

# Shell {{{1
function is_zsh() {
  [ -n "${ZSH_VERSION:-}" ]
}

function is_bash() {
  [ -n "${BASH_VERSION:-}" ]
}

# Helper functions {{{1

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

# TMP
export TMP=/tmp

# File owner
function file-owner() {
  if is-gnu-stat; then
    stat --format=%U "$*"
  else
    stat -f '%Su' "$*"
  fi
}

function is-gnu-stat() {
  if dotf-is-mac; then
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
if [[ -t 0 && $- = *i* ]]; then
  stty -ixon
fi

# Homebrew {{{1
BREW_HOME=''
for dir in /opt/homebrew ~/.linuxbrew ~/.homebrew /usr/local; do
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
function is-n-providing-node() {
  [ "$DOTF_CONFIG_NODE_PROVIDER" = "n" ]
}

function is-nvm-providing-node() {
  [ "$DOTF_CONFIG_NODE_PROVIDER" = "nvm" ]
}

function is-fnm-providing-node() {
  [ "$DOTF_CONFIG_NODE_PROVIDER" = "fnm" ]
}

if is-n-providing-node; then
  export N_PREFIX=$HOME/.n
fi

if is-nvm-providing-node; then
  export NVM_DIR=$HOME/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh" --no-use

  node_version="$(cat "$DOTF/config/node-version")"
  DOTF_NVM_DEFAULT_PATH="$(find "$NVM_DIR/versions/node" -maxdepth 1 -type d | grep "/v$node_version" | sort -n | head -1)"
  export DOTF_NVM_DEFAULT_PATH
fi

# Node-gyp doesn't support Python 3.11
if dotf-is-mac; then
  NODE_GYP_FORCE_PYTHON="$(command ls -1 /opt/homebrew/Cellar/python@3.10/*/bin/python3.10 | head)"
  export NODE_GYP_FORCE_PYTHON
fi

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

if dotf-is-mac; then
  export CGO_CPPFLAGS="-I $BREW_HOME/include"
  export CGO_LDFLAGS="-L $BREW_HOME/lib"
fi

# LUA {{{1
export LUA_ROOT="$HOME/.apps/all/lua/default"
export LUAROCKS_ROOT="$HOME/.apps/all/luarocks/default"

# PATH {{{1
PATH="$DOTF/core/scripts:\
$DOTF/core/git/scripts:\
$DOTF/extra/scripts:\
$DOTF/extra/scripts/deno:\
$DOTF/extra/scripts/node:\
$HOME/dev/git-helpers/bin:\
$HOME/dev/qmkmd/bin:\
$DOTP/scripts:\
$DOTL/scripts"

if is-n-providing-node; then
  PATH="$PATH:$N_PREFIX/bin"
elif is-nvm-providing-node; then
  if [ -n "${NVM_BIN:-}" ] && [ -e "$NVM_BIN" ]; then
    PATH="$PATH:${NVM_BIN}"
  else
    PATH="$PATH:${DOTF_NVM_DEFAULT_PATH}/bin"
  fi
fi

PATH="$PATH:$HOME/.fzf/bin:\
$HOME/.apps/bin:\
$HOME/bin:\
$HOME/scripts:\
$HOME/.luarocks/bin:\
$LUA_ROOT/bin:\
$LUAROCKS_ROOT/bin:\
$HOME/.lua/bin:\
$HOME/.local/bin"

if [ -n "$BREW_HOME" ]; then
  PATH=$PATH:$BREW_HOME/bin:$BREW_HOME/sbin:$BREW_HOME/opt/coreutils/libexec/gnubin
fi

[ -n "$GOROOT" ] && PATH=$PATH:$GOROOT/bin:$MAIN_GOPATH/bin
for ver in 3.11 3.10 3.9 3.7 3.6; do
  [ -d $HOME/Library/Python/$ver/bin ] && PATH=$PATH:$HOME/Library/Python/$ver/bin
done

# replace bsd binaries with gnu
for pkg in coreutils findutils gnu-sed; do
  gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
  if [ -e "$gnubin" ]; then
    PATH=$PATH:$gnubin
  fi
done

if [ -e ~/.local/kitty.app ]; then
  PATH="$PATH:$HOME/.local/kitty.app/bin"
fi

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

if dotf-is-wsl; then
  PATH=$PATH:/mnt/c/Windows:/mnt/c/Windows/System32:/mnt/c/Windows/System32/WindowsPowerShell/v1.0
fi

if dotf-is-linux; then
  export DENO_INSTALL=~/.deno
  PATH=$PATH:$DENO_INSTALL/bin
fi

if is-fnm-providing-node; then
  eval "$(fnm env --use-on-cd)"
fi

export PATH

#
# Rust {{{1
if [ -e ~/.cargo/env ]; then
  source ~/.cargo/env
fi

# EDITOR {{{1

# TODO: figure this out
if [ -n "${NVIM:-}" ]; then
  export EDITOR='nvr -cc split --remote-wait'
elif [ ! -z "${VSCODE_IPC_HOOK:-}" ]; then
  # Use vscode as the editor for things like Git when run from within vscode's
  # integrated terminal
  export EDITOR="code -w"
elif dotf-has-command nvim; then
  export EDITOR=$(which nvim)
else
  export EDITOR=vim
fi

export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# TMUX {{{1
# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" && "$TERM" != "tmux" && "$TERM" != "tmux-256color" ]]; then
  export TERM=xterm-256color
fi

export TMUX_TMPDIR="$TMP/$(whoami)"
mkdir -p $TMUX_TMPDIR

# Neovim Terminal {{{1
is_in_neovim() {
  [ -n "${NVIM}" ]
}

# MISC {{{1
export SSH_TERM=xterm-color
export LESS="--RAW-CONTROL-CHARS"
export RIPGREP_CONFIG_PATH="$DOTF/core/ripgrep/ripgreprc"
PRETTY_HOST="$(dotf-pretty-hostname)"
SHORT_HOST="${PRETTY_HOST:0:3}"
if is_zsh; then
  SHORT_HOST="${SHORT_HOST:l}"
fi
export PRETTY_HOST
export SHORT_HOST

# - Don't follow non-constant sources
#   (https://github.com/koalaman/shellcheck/wiki/SC1090)
# - Source file not found (https://github.com/koalaman/shellcheck/wiki/SC1091)
export SHELLCHECK_OPTS="-e SC1090,SC1091"

if dotf-is-mac; then
  JAVA_HOME="$(/usr/libexec/java_home 2> /dev/null || true)"
  if [ -n "$JAVA_HOME" ]; then
    export JAVA_HOME
  fi
fi

# DOTLOCAL {{{1
source_if_exists "$DOTL/zsh/core.zsh"
source_if_exists "$DOTL/zsh/core.sh"

# vim: foldmethod=marker
