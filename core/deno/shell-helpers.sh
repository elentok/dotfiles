#!/usr/bin/env bash

# run deno task
function dt() {

  if [ $# -gt 0 ]; then
    deno task "$@"
    return $?
  fi

  task="$(deno-tasks | fzf-tmux -p --prompt 'Pick task: ' --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$task" ]; then
    print -s "deno task $task" \
      && echo "> deno task $task" \
      && deno task "$task"
  fi
}

function deno-tasks() {
  deno task 2>&1 \
    | grep -v 'Available tasks:' \
    | tr '\n' '\r' \
    | sed -e 's/\r    / /g' \
    | tr '\r' '\n' \
    | sed 's/^- //'
}
