#!/usr/bin/env bash
# vim: foldmethod=marker
#
# Helper methods for identifying OS and Distro.
#

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

dotf-is-wsl() {
  dotf-is-linux && [[ "$(cat /proc/version)" =~ 'microsoft' ]]
}

dotf-is-linux-arm() {
  dotf-is-linux && [ "$(dpkg --print-architecture)" = "armhf" ]
}

dotf-is-ubuntu() {
  dotf-is-linux && grep Ubuntu /etc/issue > /dev/null 2>&1
}
