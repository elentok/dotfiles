if [ -n "$TMUX" ]; then
  export SSH_AUTH_SOCK="$HOME/.ssh/default-agent"
  agent fix
fi
