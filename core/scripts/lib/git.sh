#!/usr/bin/env bash

dotf-git-repo-is-dirty() {
  local dir="$1"
  [ "$(cd "$dir" && git status --porcelain --untracked=no)" != "" ]
}
