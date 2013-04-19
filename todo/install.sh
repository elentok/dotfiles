#!/bin/bash

source `dirname $0`/../config.sh

install_todo() {
  if [ "$OS" == "mac" ]; then
    brew_install todo-txt
  else
    error "TODO: IMPLEMENT THIS"
  fi
}

header "Todo.txt"
if [ "$1" != "symlinks" ]; then
  install_todo
fi
