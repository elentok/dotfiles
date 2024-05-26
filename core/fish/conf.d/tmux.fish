function tmux-set-title
    if test -n "$TMUX"
        tmux rename-window "$(basename $PWD)"
    end
end

function change-tmux-title-on-dirchange --on-variable PWD
    tmux-set-title
end

tmux-set-title
