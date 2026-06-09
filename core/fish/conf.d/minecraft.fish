set -x PRISM_LAUNCHER_ROOT "$HOME/Library/Application Support/PrismLauncher/instances"

function minecraft-versions
    for dir in $PRISM_LAUNCHER_ROOT/*/
        echo (basename $dir)
    end
end

function gmc --description "jump to minecraft instance"
    set dir $(minecraft-versions | fzf)
    if test -n "$dir"
        cd "$PRISM_LAUNCHER_ROOT/$dir"
    end
end
