__select-alias() {
  local alias="$(git-aliases | $(__fzfcmd) --ansi --exit-0 | awk '{print $1}')"
  if [ -n "$alias" ]; then
    echo "git $alias "
    return 0
  fi
  return 1
}

git-aliases-widget() {
  LBUFFER="${LBUFFER}$(__select-alias)"
  local ret=$?
  zle redisplay
  typeset -f zle-line-init >/dev/null && zle zle-line-init
  return $ret
}
zle     -N   git-aliases-widget
bindkey '^G' git-aliases-widget
