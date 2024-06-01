alias ... 'cd ../..'
alias .... 'cd ../../..'
alias v nvim
alias vi nvim
alias vg 'nvim "+Neogit kind=replace"'
alias g git
alias dotfi 'cd $DOTF'
alias dotp 'cd $DOTP && cd "$(command ls -1 | fzf-tmux -p --select-1)"'
alias o dotf-open
alias y 'dotf-clipboard copy'
alias p 'dotf-clipboard paste'
alias ts 'tig status'
alias psg 'ps -a -x -o user,pid,command | grep'
alias pth 'echo $PATH | tr " " "\n"'
# alias ls 'ls --color=always -XFhs --group-directories-first --time-style=long-iso'
alias l 'eza --classify --group-directories-first --time-style=long-iso --icons'
alias ls 'eza --classify --group-directories-first --time-style=long-iso --icons'
alias ll 'eza --long --classify --group-directories-first --time-style=long-iso --icons'

alias x exit

alias ew 'whichx $EDITOR'
alias cw 'whichx cat'

alias jw 'cd $(git-wt pick || pwd)'
alias jp 'cd $(dotf-projects pick || pwd)'

alias h 'help.ts'
alias mycal 'mycal.ts'
alias dff 'dff.ts'

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
    else if test -n "$(tmux list-sessions 2> /dev/null)"
        echo "Attaching to existing tmux session..."
        dotf-tmux attach
    else
        echo "No existing tmux session found, creating new session..."
        dotf-tmux -u
    end
end
