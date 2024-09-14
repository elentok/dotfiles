function tmux-set-title
    if test -z "$TMUX"
        return
    end

    # Prevent processes running from inside Neovim from changing the title
    if test -n "$VIMRUNTIME"
        return
    end

    if test -z "$argv[1]"
        set suffix "  "
    else
        set suffix "$argv[1]"
    end

    if test "$PWD" = "$HOME"
        set dir "~"
    else
        set dir "$(basename $PWD)"
    end

    set branch ""
    if test -n "$GIT_BRANCH" -a "$GIT_BRANCH" != main -a "$GIT_BRANCH" != "$dir"
        set branch " ($GIT_BRANCH)"
    end

    tmux rename-window "$dir$branch$suffix"
end

function change-git-branch-on-dirchange --on-variable PWD
    set -x -g GIT_BRANCH (git rev-parse --abbrev-ref HEAD 2>/dev/null)
end

change-git-branch-on-dirchange

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
