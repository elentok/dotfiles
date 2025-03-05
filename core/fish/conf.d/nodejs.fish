alias jy 'cd $(yarn-pkgs pick || pwd)'
alias yrb 'yarn && yarn build'

set -gx YARN_ENABLE_COLORS false
set -gx YARN_ENABLE_TELEMETRY false
set -gx YARN_PROGRESS_BAR_STYLE patrick
set -gx YARN_CACHE_FOLDER ~/.cache/yarn
set -gx TURBO_CACHE_DIR ~/.cache/turbo

function yr --description "yarn run"
    if test (count $argv) -gt 0
        yarn run $argv
    else
        set cmd "$(npm-scripts.ts | fzf-tmux -p -w 80% --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            history append "yarn run \"$cmd\""
            yarn run "$cmd"
        end
    end
end

function yt --description "yarn test"
    if test (count $argv) -gt 0
        yarn test $argv
    else
        set cmd "$(npm-scripts.ts | fzf-tmux -p -w 80% --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            history append "yarn test \"$cmd\""
            yarn test "$cmd"
        end
    end
end

function npr --description "npm run"
    if test (count $argv) -gt 0
        npm run $argv
    else
        set cmd "$(npm-scripts.ts | fzf-tmux -p -w 80% --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            history append "npm run \"$cmd\""
            npm run "$cmd"
        end
    end
end

function br --description "bun run"
    if test (count $argv) -gt 0
        bun run $argv
    else
        set cmd "$(npm-scripts.ts | fzf-tmux -p -w 80% --ansi --exit-0 | awk '{print $1}')"
        if test -n "$cmd"
            history append "bun run \"$cmd\""
            bun run "$cmd"
        end
    end
end
