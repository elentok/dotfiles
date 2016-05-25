# Trigger fzf completion
my-fzf-trigger-completion() {
  LBUFFER="${LBUFFER}**"
  zle fzf-completion
}

zle -N my-fzf-trigger-completion
bindkey '^f' my-fzf-trigger-completion

# vim: foldmethod=marker
