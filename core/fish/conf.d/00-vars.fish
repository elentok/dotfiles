# Clear all paths before adding new ones
set -e fish_user_paths

set -x DOTF "$HOME/.dotfiles"
set -x DOTP "$HOME/.dotplugins"
set -x EDITOR nvim

set -x TMP $HOME/tmp
mkdir -p "$TMP"

set -x FZF_DEFAULT_OPTS "--tiebreak=end"
