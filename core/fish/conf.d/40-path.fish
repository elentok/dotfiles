set -l dotp_script_paths
if test -d "$DOTP"
    for dir in $DOTP/*/scripts
        if test -d "$dir"
            set dotp_script_paths $dotp_script_paths "$dir"
        end
    end
end

fish_add_path "$HOME/.local/bin" \
    "$HOME/.cargo/bin" \
    "$HOME/dev/qmkmd/bin" \
    "$HOME/dev/git-helpers/bin" \
    "$HOME/dev/rename/bin" \
    "$DOTF/extra/scripts/deno" \
    "$DOTF/extra/scripts" \
    "$DOTF/core/git/scripts" \
    "$DOTF/core/scripts" \
    "$DOTF/extra/bin" \
    "$HOME/.deno/bin" \
    "$HOME/.apps/bin" \
    "$BUN_INSTALL/bin" \
    "$HOME/go/bin" \
    $dotp_script_paths
