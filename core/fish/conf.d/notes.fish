function jn --description 'jump to note'
    jnn
    nvim -c FzfLuaNote
end

function jnn --description 'jump to notes repo'
    if test -e ~/notes/.git
        if string match -q "$HOME/notes" $PWD
            return
        end

        cd ~/notes
    else
        cd ~/notes
        set repo "$(command ls -1 | fzf --tmux --ansi --exit-0 --select-1)"
        cd $repo
    end
end
