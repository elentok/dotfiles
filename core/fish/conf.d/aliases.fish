abbr --add ... 'cd ../..'
abbr --add .... 'cd ../../..'
abbr --add v nvim
abbr --add vi nvim
abbr --add vg 'nvim "+Neogit kind=replace"'
abbr --add g git
abbr --add o dotf-open
abbr --add y 'dotf-clipboard copy'
abbr --add p 'dotf-clipboard paste'
abbr --add ts 'tig status'
abbr --add psg 'ps -a -x -o user,pid,command | grep'

function dotfi
    cd $DOTF
end

function dotp
    cd $DOTP && cd "$(command ls -1 | fzf-tmux -p --select-1)"
end

function pth --description "Pretty print PATH"
    echo $PATH | tr " " "\n"
end

# alias ls 'ls --color=always -XFhs --group-directories-first --time-style=long-iso'
function ls
    eza --classify --group-directories-first --time-style=long-iso --icons $argv
end

abbr --add l ls
abbr --add ll ls --long
abbr --add lla ls --all
abbr --add llt ls --tree

abbr --add lg lazygit
abbr --add lgs 'lazygit status'
abbr --add lgl 'lazygit log'

function ssh
    TERM=xterm-256color command ssh $argv
end

abbr --add gs 'git status'
abbr --add gl 'git log -n 10'
abbr --add gll 'git log'

abbr --add x exit

# alias ew 'whichx $EDITOR'
# alias cw 'whichx cat'

function jw
    cd $(git-wt pick || pwd)
end

function jp
    cd $(dotf-projects pick || pwd)
end

function jt
    cd $(dotf-tmux-pick-workdir || pwd)
end

abbr --add jn 'cd ~/notes'

abbr --add h 'help.ts'
abbr --add mycal 'mycal.ts'
abbr --add dff 'dff.ts'
abbr --add sm 'sum.ts'
abbr --add dotff '~/.dotfiles/core/framework/dotf.ts'
abbr --add q qalc
abbr --add ic 'chafa -f kitty'

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
