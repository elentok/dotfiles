alias ... 'cd ../..'
alias .... 'cd ../../..'
alias v nvim
alias vi nvim
alias vg 'nvim "+Neogit kind=replace"'
alias g git
alias dotfi 'cd $DOTF'
alias o dotf-open
alias y 'dotf-clipboard copy'
alias p 'dotf-clipboard paste'
alias ts 'tig status'

alias x exit

alias ew 'whichx $EDITOR'
alias cw 'whichx cat'

alias jw 'cd $(git-wt pick || pwd)'
alias jp 'cd $(dotf-projects pick || pwd)'

function f --description vifm
    if test (count $argv) -eq 0
        TERM=xterm-256color vifm .
    else
        TERM=xterm-256color vifm $argv
    end
end

# If a tmux session exists, attach to it, otherwise create a new one.
function tm --description tmux
    if test -n "$TMUX"
        echo "Error: already inside a tmux session!"
        elif [ -n "$(tmux list-sessions 2> /dev/null)" ]
        then
        echo "Attaching to existing tmux session..."
        tmux attach
    else
        echo "No existing tmux session found, creating new session..."
        tmux -u
    end
end
