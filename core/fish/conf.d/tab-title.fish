if ! status is-interactive
    return
end

function _cmd_to_suffix
    if string match -q "nvim*" $argv[1]
        echo "  "
    else if string match -q "lazyg*" $argv[1]
        echo "  "
    else if string match -q "npm run*" $argv[1]
        string-ellipsis 10 (string replace "npm run " "  " $argv[1])
    else if string match -q "npx vitest*" $argv[1]
        string-ellipsis 10 (string replace "npx vitest " "  " $argv[1])
    else if string match -q "npm run test*" $argv[1]
        echo "  "
    else
        set short_cmd (string-ellipsis 10 $argv[1])
        echo " > $short_cmd"
    end
end

function _tab_title
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
        set suffix (_cmd_to_suffix "$argv[1]")
    end

    if test "$PWD" = "$HOME"
        set dir "~"
    else
        set dir (basename $PWD)

        if contains -- $dir main master
            set parent_dir (basename (dirname $PWD))
            set dir "$parent_dir/$dir"
        end
    end

    set short_dir (string-ellipsis 25 $dir)

    set branch ""
    # If there is a branch and it's not the same as the directory name, add it
    # to the tab title
    # if test -n "$GIT_BRANCH" -a "$GIT_BRANCH" != main -a "$GIT_BRANCH" != "$dir"
    #     set short_branch (string-ellipsis 20 $GIT_BRANCH)
    #     set branch " ( $short_branch)"
    # end

    # set cmd (string split ' ' $argv[1])[1]
    echo "$short_dir$branch$suffix"
end

function _set_tmux_pane_title
    set -q TMUX; or return

    set -l title (_tab_title "$argv[1]")
    test -n "$title"; or return

    tmux select-pane -T "$title" >/dev/null 2>/dev/null
end

function fish_title
    if test -n "$TMUX"
        _set_tmux_pane_title "$argv[1]"
        return
    end

    _tab_title "$argv[1]"
end

function _set_tmux_pane_title_on_prompt --on-event fish_prompt
    _set_tmux_pane_title
end

function _set_tmux_pane_title_on_preexec --on-event fish_preexec
    _set_tmux_pane_title "$argv[1]"
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

# function change-git-branch-on-dirchange --on-variable PWD
#     set -x -g GIT_BRANCH (git rev-parse --abbrev-ref HEAD 2>/dev/null)
# end
#
# change-git-branch-on-dirchange
