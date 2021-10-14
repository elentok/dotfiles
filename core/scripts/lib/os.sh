#!/usr/bin/env bash
# vim: foldmethod=marker
#
# Helper methods for identifying OS and Distro.
#

# Identify OS {{{1
if [ "$(uname -s)" = "Darwin" ]; then
  export OS=mac
else
  export OS=linux
fi

dotf-is-mac() {
  [ "$OS" = "mac" ]
}

dotf-is-linux() {
  [ "$OS" = "linux" ]
}

# Identify Linux Distro {{{1
export DISTRO=''
if dotf-is-linux; then
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

# Identify WSL {{{1
export IS_WSL=no

if dotf-is-linux; then
  if ! is_termux; then
    if [[ "$(cat /proc/version)" =~ 'microsoft' ]]; then
      export IS_WSL=yes
    fi
  fi
fi

is_wsl() {
  [ "$IS_WSL" = "yes" ]
}

# Identify ARM {{{1

is_arm() {
  [ "$(dpkg --print-architecture)" = "armhf" ]
}
