set -x BREW_HOME ''
for dir in /opt/homebrew /home/linuxbrew/.linuxbrew ~/.linuxbrew ~/.homebrew /usr/local
    if test -e "$dir/bin/brew"
        set -x BREW_HOME $dir
        break
    end
end

if test -e "$BREW_HOME"
    if test -e "$BREW_HOME/Homebrew"
        set -x BREW_ROOT "$BREW_HOME/Homebrew"
    else
        set -x BREW_ROOT "$BREW_HOME"
    end

    fish_add_path "$BREW_HOME/opt/coreutils/libexec/gnubin"
    fish_add_path "$BREW_HOME/sbin"
    fish_add_path "$BREW_HOME/bin"
end
