function tmux-set-title
    if test -n "$TMUX"
        if test "$PWD" = "$HOME"
            set dir "~"
        else
            set dir "$(basename $PWD)"
        end
        tmux rename-window "$dir$argv[1]"
    end
end

function change-tmux-title-on-prompt --on-event fish_prompt
    tmux-set-title ":fish"
end

function change-tmux-title-on-preexec --on-event fish_preexec
    set cmd (string split ' ' $argv[1])[1]
    if test "$cmd" != x -a "$cmd" != cd -a "$cmd" != ls -a "$cmd" != v
        tmux-set-title ":$cmd"
    end
end

tmux-set-title ":fish"
