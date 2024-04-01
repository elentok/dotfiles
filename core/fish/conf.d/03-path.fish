fish_add_path "$HOME/.local/bin"
fish_add_path "$HOME/.apps/bin"
fish_add_path "$HOME/.fzf/bin"
fish_add_path "$HOME/dev/qmkmd/bin"
fish_add_path "$HOME/dev/git-helpers/bin"
fish_add_path "$DOTF/extra/scripts/node"
fish_add_path "$DOTF/extra/scripts/deno"
fish_add_path "$DOTF/extra/scripts"
fish_add_path "$DOTF/core/git/scripts"
fish_add_path "$DOTF/core/scripts"

for dir in $DOTP/*/scripts
    fish_add_path $dir
end
