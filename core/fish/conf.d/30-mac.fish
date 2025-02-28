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
