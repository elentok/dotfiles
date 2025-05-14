function fish_title
    # set -q argv[1]; or set argv fish

    # Prevent processes running from inside Neovim from changing the title
    if test -n "$VIMRUNTIME"
        return
    end

    if test -z "$argv[1]"
        set suffix ""
        # set suffix "  "
        # set suffix "  "
    else
        set cmd (string-ellipsis 10 $argv[1])
        set suffix " > $cmd"
    end

    if test "$PWD" = "$HOME"
        set dir "~"
    else
        set dir (basename $PWD)
    end

    set short_dir (string-ellipsis 25 $dir)

    set branch ""
    # If there is a branch and it's not the same as the directory name, add it
    # to the tab title
    if test -n "$GIT_BRANCH" -a "$GIT_BRANCH" != main -a "$GIT_BRANCH" != "$dir"
        set short_branch (string-ellipsis 20 $GIT_BRANCH)
        set branch " ( $short_branch)"
    end

    # set cmd (string split ' ' $argv[1])[1]
    echo "$short_dir$branch$suffix"
end

function string-ellipsis
    set length $argv[1]
    set text $argv[2]

    set length_start (math "round($length / 2)")
    set length_end (math "$length - $length_start")

    if test (string length $text) -gt $length
        echo "$(string sub -l $length_start $text)…$(string sub -s -$length_end $text)"
    else
        echo $text
    end

end

function change-git-branch-on-dirchange --on-variable PWD
    set -x -g GIT_BRANCH (git rev-parse --abbrev-ref HEAD 2>/dev/null)
end

change-git-branch-on-dirchange
