if dotf-is-mac
    # Increase max file limit
    ulimit -n 4096

    if test -e "$BREW_HOME"
        if test -e "$BREW_HOME/Homebrew"
            set -x BREW_ROOT "$BREW_HOME/Homebrew"
        else
            set -x BREW_ROOT "$BREW_HOME"
        end
    end

    set pyver "$(command ls ~/Library/Python | sort -V | tail -1)"
    if test -d "$HOME/Library/Python/$pyver/bin"
        fish_add_path "$HOME/Library/Python/$pyver/bin"
    end

    if test -n "$BREW_HOME"
        fish_add_path "$BREW_HOME/opt/coreutils/libexec/gnubin"
        fish_add_path "$BREW_HOME/sbin"
        fish_add_path "$BREW_HOME/bin"
    end

    # replace bsd binaries with gnu
    for pkg in coreutils findutils gnu-sed
        set gnubin "$BREW_HOME/opt/$pkg/libexec/gnubin"
        if test -e "$gnubin"
            fish_add_path "$gnubin"
        end
    end
end
