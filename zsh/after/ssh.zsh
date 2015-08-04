export SSH_AUTH_SOCK="/tmp/ssh-agent-$USER-tmux"

if [ ! -e "$SSH_AUTH_SOCK" ]; then
  echo "Creating new ssh-agent on $SSH_AUTH_SOCK"
  mkdir -p $(dirname $SSH_AUTH_SOCK)
  eval $(ssh-agent -a $SSH_AUTH_SOCK)
fi
