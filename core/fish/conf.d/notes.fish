function jn --description 'jump to note'
    jnn
    nvim -c ObsidianQuickSwitch
end

function jnn --description 'jump to notes repo'
    if test -e ~/notes/.git
        if string match -q "$HOME/notes" $PWD
            return
        end

        cd ~/notes
    else
        cd ~/notes
        set repo "$(command ls -1 | fzf-tmux -p --ansi --exit-0)"
        cd $repo
    end
end
