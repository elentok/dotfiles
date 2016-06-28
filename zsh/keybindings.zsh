# ^f: fzf completion {{{1
my-fzf-trigger-completion() {
  LBUFFER="${LBUFFER}**"
  zle fzf-completion
}

zle -N my-fzf-trigger-completion
bindkey '^f' my-fzf-trigger-completion

# ^xb: branch completion {{{1

my-branch-completion() {
  LBUFFER="${LBUFFER}$(git all-branches | fzf)"
  local ret=$?
  zle redisplay
  return $ret
}

zle -N my-branch-completion
bindkey '^xb' my-branch-completion

# vim: foldmethod=marker
