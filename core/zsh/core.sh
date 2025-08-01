# vim: foldmethod=marker

_core_start=$SECONDS
export DOTF=~/.dotfiles
export DOTL=~/.dotlocal
export DOTP=~/.dotplugins

source "$DOTF/core/scripts/lib/os.sh"
source "$DOTF/core/scripts/lib/core-helpers.sh"

# Helper: Source If Exists {{{1
# source_if_exists() {
#   if [ -e "$1" ]; then source "$1"; fi
# }

# Load Configuration {{{1
source "$DOTF/core/zsh/config.sh"
for configfile in $(dotf-plugin-list-files zsh/config.sh); do
  source "$configfile"
done

# TMP
export TMP=$HOME/tmp
mkdir -p "$TMP"

# Disable <Ctrl-s> lock on interactive shells {{{1
# see:
# * https://stackoverflow.com/questions/24623021
# * https://unix.stackexchange.com/questions/72086
# * https://unix.stackexchange.com/questions/26676
if [[ -t 0 && $- = *i* ]]; then
  stty -ixon
fi

# ulimit {{{1
if dotf-is-mac; then
  # Increase max file limit
  ulimit -n 4096
fi

# Homebrew {{{1
BREW_HOME=''
for dir in /opt/homebrew /home/linuxbrew/.linuxbrew ~/.linuxbrew ~/.homebrew /usr/local; do
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
#
# Node-gyp doesn't support Python 3.11
if dotf-is-mac; then
  NODE_GYP_FORCE_PYTHON="$(command ls -1 /opt/homebrew/Cellar/python@3.10/*/bin/python3.10 | head)"
  if [ -e "$NODE_GYP_FORCE_PYTHON" ]; then
    export NODE_GYP_FORCE_PYTHON
  fi
fi

# Go {{{1
if [ -e "$HOME/.apps/go" ]; then
  export GOROOT=$HOME/.apps/go
elif dotf-is-mac; then
  export GOROOT=$BREW_HOME/opt/go/libexec
fi
export MAIN_GOPATH=$HOME/go
export GOPATH=$MAIN_GOPATH
export GO15VENDOREXPERIMENT=1

if dotf-is-mac; then
  if [ -d "$BREW_HOME/share/app-engine-go-64/goroot" ]; then
    export GOPATH=$GOPATH:$BREW_HOME/share/app-engine-go-64/goroot
  fi

  export CGO_CPPFLAGS="-I $BREW_HOME/include"
  export CGO_LDFLAGS="-L $BREW_HOME/lib"
fi

# LUA {{{1
# export LUA_ROOT="$HOME/.apps/all/lua/default"
# export LUAROCKS_ROOT="$HOME/.apps/all/luarocks/default"

# Deno {{{1
if dotf-is-linux; then
  export DENO_INSTALL=~/.deno
fi

# PATH {{{1
function dotf-gen-path() {
  echo "$DOTF/core/scripts"
  echo "$DOTF/core/git/scripts"
  echo "$DOTF/extra/scripts"
  echo "$DOTF/extra/scripts/deno"
  echo "$DOTF/extra/scripts/node"
  echo "$HOME/dev/git-helpers/bin"
  echo "$HOME/dev/qmkmd/bin"
  dotf-plugin-list-files scripts

  echo "$HOME/.local/share/fnm"
  echo "$HOME/.fzf/bin"
  echo "$HOME/.apps/bin"
  echo "$HOME/.local/bin"

  if [ -n "${GOROOT:-}" ]; then
    echo "$GOROOT/bin"
    echo "$MAIN_GOPATH/bin"
  fi

  if [ -n "$BREW_HOME" ]; then
    echo "$BREW_HOME/bin"
    echo "$BREW_HOME/sbin"
  fi

  if dotf-is-mac; then
    if [ -n "$BREW_HOME" ]; then
      echo "$BREW_HOME/opt/coreutils/libexec/gnubin"
    fi

    local pyver
    pyver="$(command ls ~/Library/Python | sort -V | tail -1)"
    if [ -d "$HOME/Library/Python/$pyver/bin" ]; then
      echo "$HOME/Library/Python/$pyver/bin"
    fi

    # replace bsd binaries with gnu
    for pkg in coreutils findutils gnu-sed; do
      gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
      if [ -e "$gnubin" ]; then
        echo "$gnubin"
      fi
    done
  fi

  if [ -e ~/.local/kitty.app ]; then
    echo "$HOME/.local/kitty.app/bin"
  fi

  echo "$HOME/.cargo/bin"
  echo "/snap/bin"
  echo "/usr/local/share/npm/bin"
  echo "/usr/local/bin"
  echo "/usr/local/sbin"
  echo "/usr/games"
  echo "/usr/bin"
  echo "/bin"
  echo "/usr/sbin"
  echo "/sbin"

  # if dotf-is-wsl; then
  #   echo "/mnt/c/Windows"
  #   echo "/mnt/c/Windows/System32"
  #   echo "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
  # fi

  if [ -e "${DENO_INSTALL:-}" ]; then
    echo "$DENO_INSTALL/bin"
  fi
}

_core_genpath_start=$SECONDS
new_path="$(dotf-gen-path | tr '\n' ':')"
# remove last colon
new_path="${new_path::${#new_path}-1}"
_core_genpath_elapsed_ms=$(((SECONDS - _core_genpath_start) * 1000))

export PATH="$new_path"

if dotf-has-command fnm; then
  eval "$(fnm env --use-on-cd)"
else
  echo "WARNING: missing fnm command (this warning is to be expected when bootstraping a new system)"
fi

# Rust {{{1
if [ -e ~/.cargo/env ]; then
  source ~/.cargo/env
fi

# EDITOR {{{1

EDITOR=nvim
export EDITOR
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# TMUX {{{1
# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" && "$TERM" != "tmux" && "$TERM" != "tmux-256color" ]]; then
  export TERM=xterm-256color
fi

TMUX_TMPDIR="$HOME/tmp/tmux"
export TMUX_TMPDIR
mkdir -p "$TMUX_TMPDIR"

# SSH {{{1
export SSH_TERM=xterm-color
# export SSH_AUTH_SOCK="$HOME/.ssh/active-agent"
# SSH_AGENT_PID="$([ -e ~/.ssh/local-agent-pid ] && cat ~/.ssh/local-agent-pid)"
# export SSH_AGENT_PID

# MISC {{{1
export LESS="--RAW-CONTROL-CHARS"
export RIPGREP_CONFIG_PATH="$DOTF/core/ripgrep/ripgreprc"

# - Don't follow non-constant sources
#   (https://github.com/koalaman/shellcheck/wiki/SC1090)
# - Source file not found (https://github.com/koalaman/shellcheck/wiki/SC1091)
export SHELLCHECK_OPTS="-e SC1090,SC1091"

if dotf-is-mac; then
  JAVA_HOME="$(/usr/libexec/java_home 2>/dev/null || true)"
  if [ -n "$JAVA_HOME" ]; then
    export JAVA_HOME
  fi
fi

# Plugins {{{1
for configfile in $(dotf-plugin-list-files zsh/core.sh); do
  source "$configfile"
done

# Timing checks {{{1
_core_elapsed_ms=$(((SECONDS - _core_start) * 1000))
if [[ $_core_elapsed_ms -gt 25 ]]; then
  echo "Warning: zsh/core.sh took $(printf '%.2f' $_core_elapsed_ms)ms to load"
fi

if [[ $_core_genpath_elapsed_ms -gt 5 ]]; then
  echo "Warning: core.sh gen-path took $(printf '%.2f' $_core_genpath_elapsed_ms)ms to load"
fi
