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

# Identify WSL {{{1
export IS_WSL=no

if dotf-is-linux; then
  if [[ "$(cat /proc/version)" =~ 'microsoft' ]]; then
    export IS_WSL=yes
  fi
fi

dotf-is-wsl() {
  [ "$IS_WSL" = "yes" ]
}

# Identify Linux ARM {{{1

dotf-is-linux-arm() {
  dotf-is-linux && [ "$(dpkg --print-architecture)" = "armhf" ]
}
