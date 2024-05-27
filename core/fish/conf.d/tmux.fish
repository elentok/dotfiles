function tmux-set-title
    if test -z "$TMUX"
        return
    end

    # Prevent processes running from inside Neovim from changing the title
    if test -n "$VIMRUNTIME"
        return
    end

    if test -z "$argv[1]"
        set suffix " "
    else
        set suffix "$argv[1]"
    end

    if test "$PWD" = "$HOME"
        set dir "~"
    else
        set dir "$(basename $PWD)"
    end
    tmux rename-window "$dir$suffix"
end

function change-tmux-title-on-prompt --on-event fish_prompt
    tmux-set-title
end

function change-tmux-title-on-preexec --on-event fish_preexec
    set cmd (string split ' ' $argv[1])[1]
    if test "$cmd" != x -a "$cmd" != cd -a "$cmd" != ls -a "$cmd" != v -a "$cmd" != vi
        tmux-set-title ":$cmd"
    end
end

tmux-set-title
