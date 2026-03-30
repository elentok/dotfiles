# Clear all paths before adding new ones
set -e fish_user_paths

set -x DOTF "$HOME/.dotfiles"
set -x DOTP "$HOME/.dotplugins"
set -x EDITOR nvim
set -x GIT_EDITOR nvim -c startinsert

set -x TMP $HOME/tmp
if ! test -e "$TMP"
    mkdir -p "$TMP"
end

set -x FZF_DEFAULT_OPTS "--tiebreak=end"
set -x BUN_INSTALL "$HOME/.bin"

set -x MANPAGER "nvim +Man!"
