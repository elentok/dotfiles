if ! dotf-is-mac
    return
end

# Increase max file limit
ulimit -n 4096

fish_add_path \
    "$BREW_HOME/opt/coreutils/libexec/gnubin" \
    "$BREW_HOME/opt/findutils/libexec/gnubin" \
    "$BREW_HOME/opt/gnu-sed/libexec/gnubin"

set -gx COLIMA_HOME "$HOME/.colima"
if test -e "$COLIMA_HOME"
    set -gx DOCKER_HOST "unix://$COLIMA_HOME/default/docker.sock"
end
