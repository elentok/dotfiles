function fish_title
    # set -q argv[1]; or set argv fish

    # Prevent processes running from inside Neovim from changing the title
    if test -n "$VIMRUNTIME"
        return
    end

    if test -z "$argv[1]"
        set suffix "  "
        # set suffix "  "
    else
        set suffix " > $argv[1]"
    end

    if test "$PWD" = "$HOME"
        set dir "~"
    else
        set dir (basename $PWD)
        set dir (string-ellipsis 10 $dir)
    end

    set branch ""
    if test -n "$GIT_BRANCH" -a "$GIT_BRANCH" != main -a "$GIT_BRANCH" != "$dir"
        set short_branch (string-ellipsis 10 $GIT_BRANCH)
        set branch " ($short_branch)"
    end

    # set cmd (string split ' ' $argv[1])[1]
    echo "$dir$branch$suffix"
end

function string-ellipsis
    set length $argv[1]
    set text $argv[2]

    if test (string length $text) -gt $length
        echo (string sub -l $length $text)...
    else
        echo $text
    end

end
