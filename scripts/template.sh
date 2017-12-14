#!/usr/bin/env bash

source $DOTF/framework

main() {
  if [ $# -eq 0 ]; then
    usage
  else
    run "$@"
  fi
}

usage() {
  cat<<EOF

{{script-name}}

Usage:
  {{script-name}} ship new <name>...
  {{script-name}} ship <name> move <x> <y> [--speed=<kn>]
  {{script-name}} ship shoot <x> <y>
  {{script-name}} mine (set|remove) <x> <y> [--moored|--drifting]
  {{script-name}} -h | --help
  {{script-name}} --version

Options:
  -h --help     Show this screen.
  --version     Show version.
  --speed=<kn>  Speed in knots [default: 10].
  --moored      Moored (anchored) mine.
  --drifting    Drifting mine.

EOF
}

run() {
  echo 'hello'
}

main "$@"
