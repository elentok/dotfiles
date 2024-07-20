if dotf-is-mac
    # Increase max file limit
    ulimit -n 4096

    set pyver "$(command ls ~/Library/Python | sort -V | tail -1)"
    if test -d "$HOME/Library/Python/$pyver/bin"
        fish_add_path "$HOME/Library/Python/$pyver/bin"
    end

    # replace bsd binaries with gnu
    for pkg in coreutils findutils gnu-sed
        set gnubin "$BREW_HOME/opt/$pkg/libexec/gnubin"
        if test -e "$gnubin"
            fish_add_path "$gnubin"
        end
    end
end
