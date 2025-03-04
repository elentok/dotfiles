set _direnv_cache ~/.cache/dotfiles/direnv.fish

if ! test -e $_direnv_cache
    mkdir -p (dirname $_direnv_cache)
    direnv hook fish >$_direnv_cache
end

source $_direnv_cache
