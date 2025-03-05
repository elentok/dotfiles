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
alias lg lazygit
alias lgs 'lazygit status'
alias lgl 'lazygit log'
alias ssh 'TERM=xterm-256color command ssh'

alias gl 'git log -n 10'
alias gll 'git log'

alias x exit

alias ew 'whichx $EDITOR'
alias cw 'whichx cat'

alias jw 'cd $(git-wt pick || pwd)'
alias jp 'cd $(dotf-projects pick || pwd)'
alias jt 'cd $(dotf-tmux-pick-workdir || pwd)'

alias h 'help.ts'
alias mycal 'mycal.ts'
alias dff 'dff.ts'
alias sm 'sum.ts'
alias dotff '~/.dotfiles/core/framework/dotf.ts'
alias q qalc
alias ic 'chafa -f kitty'

function nv --description neovide
    if test -n "$TMUX"
        echo "Don't run neovide in tmux!"
    else
        neohub --opts --fork $argv
    end
end

function f --description vifm
    if test (count $argv) -eq 0
        TERM=xterm-256color vifm .
    else
        TERM=xterm-256color vifm $argv
    end
end

function y --description "yazi wrapper"
    set tmp (mktemp -t "yazi-cwd.XXXXXX")
    yazi $argv --cwd-file="$tmp"
    if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
        builtin cd -- "$cwd"
    end
    rm -f -- "$tmp"
end
