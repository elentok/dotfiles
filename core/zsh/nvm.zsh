#!/usr/bin/env zsh

export DOTF_NVMRC=""

function dotf-nvm-use() {
  local nvmrc
  nvmrc="$(nvm_find_nvmrc)"

  if [ "$nvmrc" != "$DOTF_NVMRC" ]; then
    nvm use
    export DOTF_NVMRC="$nvmrc"
  fi
}

add-zsh-hook -Uz chpwd() {
  dotf-nvm-use
}

dotf-nvm-use
