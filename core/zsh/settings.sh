#!/usr/bin/env bash
# vim: foldmethod=marker

if [ -e ~/.config/machine ]; then
  source ~/.config/machine
fi

# Android {{{1
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/build-tools/23.0.0

# Completions {{{1
fpath=($DOTF/core/zsh/vendor/zsh-completions/src $fpath)

# Functions {{{1

function encrypt() {
  openssl des3 -salt -in $* -out $*.secret
}

function decrypt() {
  openssl des3 -salt -d -in $* -out $*.plain
}

if has_command rg; then
  function ff {
    if [ $# -eq 0 ]; then
      rg --files
    else
      rg --files --iglob "*$**"
    fi
  }
else
  function ff {
    find . -iname "*$**"
  }
fi

function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

function videos() {
  ag '.' -l --nocolor -g '(mkv|avi|mp4)'
}

function pl() {
  local filename="$(videos | fzf)"
  if [ -n "$filename" ]; then
    open "$filename"
  fi
}

if is_wsl; then
  function open() {
    explorer.exe "$@"
  }
elif dotf-is-linux; then
  function open() {
    xdg-open "$@"
  }
fi

# FZF {{{1

# make FZF a little bit prettier
export FZF_DEFAULT_OPTS=''
# export FZF_DEFAULT_OPTS='--border --margin=0'

# make FZF respect .gitignore
# export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

# https://github.com/junegunn/fzf/issues/809
[ -n "${NVIM:-}" ] && export FZF_DEFAULT_OPTS='--no-height'

# SSH {{{1
if ! [[ "$SSH_AUTH_SOCK" =~ "chromoting" ]]; then

  export SSH_AUTH_SOCK="$HOME/.ssh/active-agent"
  agent setup > /dev/null
fi

# Terminal Title {{{1
dotf-term-title

# GCloud SDK {{{1

gcloud_path="$HOME/google-cloud-sdk"

if [ -e "$gcloud_path" ]; then
  # The next line updates PATH for the Google Cloud SDK.
  source "$gcloud_path/path.zsh.inc"

  # The next line enables shell command completion for gcloud.
  # Disabling this for now, it seems to cause some sort of delay on OSX
  # source "$gcloud_path/completion.zsh.inc"
fi
