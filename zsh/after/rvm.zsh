[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
if [ ! -e '.rvmrc' ]; then
  rvm default
fi
