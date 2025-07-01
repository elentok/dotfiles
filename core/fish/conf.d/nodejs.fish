function jy
    cd $(yarn-pkgs pick || pwd)
end

set -gx YARN_ENABLE_COLORS false
set -gx YARN_ENABLE_TELEMETRY false
set -gx YARN_PROGRESS_BAR_STYLE patrick
set -gx YARN_CACHE_FOLDER ~/.cache/yarn
set -gx TURBO_CACHE_DIR ~/.cache/turbo

# Node-gyp doesn't support Python 3.11
for file in $BREW_HOME/Cellar/python@3.10/*/bin/python3.10 do
    set -gx NODE_GYP_FORCE_PYTHON "$file"
    break
end

function _pick_npm_script
    # npm-scripts.ts | fzf-tmux -p -w 80% --ansi --exit-0
    tv npm-scripts
end

function yr --description "yarn run"
    if test (count $argv) -gt 0
        yarn run $argv
    else
        set cmd "$(_pick_npm_script | awk '{print $1}')"
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
        set cmd "$(_pick_npm_script | awk '{print $1}')"
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
        set cmd "$(_pick_npm_script | awk '{print $1}')"
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
        set cmd "$(_pick_npm_script | awk '{print $1}')"
        if test -n "$cmd"
            history append "bun run \"$cmd\""
            bun run "$cmd"
        end
    end
end
