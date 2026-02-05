if ! dotf-is-mac
    return
end

# Increase max file limit
ulimit -n 4096

set pyver_cache ~/.local/cache/dotfiles/pyver

if test -e $pyver_cache
    read -l pyver <$pyver_cache
else
    set pyver "$(command ls ~/Library/Python | sort -V | tail -1)"
    mkdir -p $(dirname $pyver_cache)
    echo "$pyver" >$pyver_cache
end

fish_add_path "$HOME/Library/Python/$pyver/bin" \
    "$BREW_HOME/opt/coreutils/libexec/gnubin" \
    "$BREW_HOME/opt/findutils/libexec/gnubin" \
    "$BREW_HOME/opt/gnu-sed/libexec/gnubin"

set -gx COLIMA_HOME "$HOME/.colima"
if test -e "$COLIMA_HOME"
    set -gx DOCKER_HOST "unix://$COLIMA_HOME/default/docker.sock"
end
