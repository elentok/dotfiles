# Clear all paths before adding new ones
set -e fish_user_paths

set -x DOTF "$HOME/.dotfiles"
set -x DOTP "$HOME/.dotplugins"
set -x EDITOR nvim
set -x GIT_EDITOR nvim -c startinsert
set -x CLAUDE_CODE_ENABLE_AUTO_MODE 1

set -x TMP $HOME/tmp
if ! test -e "$TMP"
    mkdir -p "$TMP"
end

# Catppuccin theme
# https://github.com/catppuccin/fzf/blob/main/themes/catppuccin-fzf-mocha.fish
set -Ux FZF_DEFAULT_OPTS "\
--tiebreak=end --popup=85%,70% --wrap-sign='󰞘 ' --wrap=word
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"

set -x BUN_INSTALL "$HOME/.bin"

set -x MANPAGER "nvim +Man!"

# https://github.com/rtk-ai/rtk/blob/develop/docs/TELEMETRY.md
set -x RTK_TELEMETRY_DISABLED 1
