function jn --description 'jump to note'
    jnn
    nvim -c ZkNotes
end

function jnn --description 'jump to notes repo'
    if test -e ~/notes/.git
        cd ~/notes
    else
        cd ~/notes
        set repo "$(command ls -1 | fzf-tmux -p --ansi --exit-0)"
        cd $repo
    end
end
