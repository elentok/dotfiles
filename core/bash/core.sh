# vim: foldmethod=marker

_core_start=$SECONDS
export DOTF=~/.dotfiles
export DOTL=~/.dotlocal
export DOTP=~/.dotplugins

source "$DOTF/core/scripts/lib/os.sh"
source "$DOTF/core/scripts/lib/core-helpers.sh"

export TMP=$HOME/tmp
if [ ! -e "$TMP" ]; then
  mkdir -p "$TMP"
fi

alias x=exit

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

# Mac specific {{{1
if dotf-is-mac; then
  # Increase max file limit
  ulimit -n 4096

  # Node-gyp doesn't support Python 3.11
  if [ -e "$BREW_HOME/Cellar/python@3.10" ]; then
    NODE_GYP_FORCE_PYTHON="$(command ls -1 $BREW_HOME/Cellar/python@3.10/*/bin/python3.10 | head)"
    if [ -e "$NODE_GYP_FORCE_PYTHON" ]; then
      export NODE_GYP_FORCE_PYTHON
    fi
  fi
fi

# PATH {{{1

path=$DOTF/core/scripts
path=$path:$DOTF/core/git/scripts
path=$path:$DOTF/extra/scripts
path=$path:$DOTF/extra/scripts/deno
path=$path:$DOTF/extra/scripts/node
path=$path:$HOME/dev/github-pkgs/bin
path=$path:$HOME/dev/git-helpers/bin
path=$path:$HOME/dev/qmkmd/bin

for plugin_dir1 in ~/.dotplugins/*; do
  if [ -e "$plugin_dir1" ]; then
    path=$path:$plugin_dir1/scripts
  fi
done

path=$path:$HOME/.local/share/fnm
path=$path:$HOME/.fzf/bin
path=$path:$HOME/.local/bin

eval "$(fnm env --use-on-cd --version-file-strategy recursive --shell bash)"

if [ -n "$BREW_HOME" ]; then
  path=$path:$BREW_HOME/bin
  path=$path:$BREW_HOME/sbin
fi

if dotf-is-mac; then
  if [ -e ~/Library/Python ]; then
    pyver="$(command ls ~/Library/Python | sort -V | tail -1)"
    if [ -d "$HOME/Library/Python/$pyver/bin" ]; then
      path=$path:$HOME/Library/Python/$pyver/bin
    fi
  fi

  # replace bsd binaries with gnu
  path=$path:$BREW_HOME/opt/coreutils/libexec/gnubin
  path=$path:$BREW_HOME/opt/findutils/libexec/gnubin
  path=$path:$BREW_HOME/opt/gnu-sed/libexec/gnubin
fi

path=$path:$HOME/.cargo/bin
path=$path:/usr/local/bin
path=$path:/usr/local/sbin
path=$path:/usr/games
path=$path:/usr/bin
path=$path:/bin
path=$path:/usr/sbin
path=$path:/sbin

export PATH=$path

# EDITOR {{{1

export EDITOR=nvim
export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# Plugins {{{1

for plugin_dir2 in ~/.dotplugins/*; do
  if [ -e "$plugin_dir2/core.sh" ]; then
    source "$plugin_dir2/core.sh"
  fi
done

# Timing checks {{{1
_core_elapsed_ms=$(((SECONDS - _core_start) * 1000))
if [[ $_core_elapsed_ms -gt 25 ]]; then
  echo "Warning: core.sh took $(printf '%.2f' $_core_elapsed_ms)ms to load"
fi
