#!/usr/bin/env bash

alias nvp='cd $(pick-plugin)'

function pick-plugin() {
  local lazy_root=~/.local/share/nvim/lazy
  cd "$lazy_root" || return 1
  plugin="$(find . -maxdepth 1 -type d | sed 's#^\./##' | fzf)"
  if [ -n "$plugin" ]; then
    echo "$lazy_root/$plugin"
  fi
}

if dotf-has-command nvim; then
  if is_in_neovim; then
    alias vi='nvr -o'
    alias vv='nvr -O'

    function nvim-set-workdir() {
      nvr --remote-send "<c-\\><c-n>:call TermSetWorkDir('$PWD')<cr>i"
    }

    function cd() {
      builtin cd "$@" || return 1
      nvim-set-workdir
    }
  else
    alias vi=dotf-nvim
  fi
else
  alias vi=vim
fi

function v() {
  if [ $# -eq 0 ]; then
    run-on-file dotf-nvim
  else
    dotf-nvim "$@"
  fi
}

function run-on-file() {
  # calling "print -s" adds the command to zsh history

  file="$(list-files | fzf --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$file" ]; then
    cmd="$* $file"
    print -s "$cmd" \
      && bash -c "$cmd"
  fi
}

function list-files() {
  find . -maxdepth 1 -type f | sed 's/^\.\///' | sort
}

function vv() {
  files="$(vifm --choose-files - --on-choose echo .)"
  if [ -n "$files" ]; then
    echo "$files" | xargs dotf-nvim
  fi
}
