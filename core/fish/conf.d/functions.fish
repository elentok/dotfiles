function dotfi
    cd $DOTF
end

function dotp
    cd $DOTP && cd "$(command ls -1 | fzf-tmux -p --select-1)"
end

function pth --description "Pretty print PATH"
    echo $PATH | tr " " "\n"
end

function ls
    eza --classify --group-directories-first --time-style=long-iso --icons $argv
end

function ssh
    TERM=xterm-256color command ssh $argv
end

# alias ew 'whichx $EDITOR'
# alias cw 'whichx cat'

function jp
    # cd $(dotf-projects pick || pwd)
    set project (tv projects)
    if test -n "$project"
        cd (string replace "~" "$HOME" $project)
    end
end

function jt
    cd $(dotf-tmux-pick-workdir || pwd)
end

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

function psg --description "ps grep"
    ps -a -x -o user,pid,command | grep $argv
end

function vc --description "neovim with clipboard contents"
    nvim '+normal [p'
end
