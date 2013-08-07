if [[ -s "$HOME/.rvm/scripts/rvm" ]]; then
  . "$HOME/.rvm/scripts/rvm"
  if [ ! -e '.rvmrc' ]; then
    rvm default
  fi
fi
