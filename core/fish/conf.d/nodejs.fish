alias jy 'cd $(yarn-pkgs pick || pwd)'

function yr --description "yarn run"
    if test (count $argv) -gt 0
        yarn run $argv
    else
        set cmd "$(npm-scripts | fzf-tmux -p --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            commandline --replace "yarn run "$cmd""
            commandline -f execute
        end
    end
end

function yt --description "yarn test"
    if test (count $argv) -gt 0
        yarn test $argv
    else
        set cmd "$(npm-scripts | fzf-tmux -p --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            commandline --replace "yarn test "$cmd""
            commandline -f execute
        end
    end
end

function npr --description "npm run"
    if test (count $argv) -gt 0
        npm run $argv
    else
        set cmd "$(npm-scripts | fzf-tmux -p --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            commandline --replace "npm run "$cmd""
            commandline -f execute
        end
    end
end
