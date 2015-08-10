if [ -n "$TMUX" ]; then
  export SSH_AUTH_SOCK="$HOME/.ssh/default-agent"
  ssh-switch fix
fi
