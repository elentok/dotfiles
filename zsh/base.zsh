export DOTF=~/.dotfiles
export DOTL=~/.dotlocal

# BREW_HOME {{{1

for dir in ~/.linuxbrew ~/.homebrew /usr/local; do
  if [ -e "$dir" ]; then
    export BREW_HOME=$dir
    break
  fi
done

# PATH {{{1


PATH=$DOTF/scripts:$DOTL/scripts
PATH=$PATH:$BREW_HOME/bin
PATH=$PATH:$HOME/bin:$HOME/scripts:$HOME/.local/bin

# replace bsd binaries with gnu
for pkg in coreutils findutils gnu-sed; do
  gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
  if [ -e "$gnubin" ]; then
    PATH=$PATH:$gnubin
  fi
done

PATH=$PATH:/usr/local/share/npm/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin

export PATH

# EDITOR {{{1

has_command() {
  type "$1" > /dev/null 2>&1
}

if has_command nvim; then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

export VISUAL=$EDITOR
export GIT_EDITOR=$EDITOR

# TMUX {{{1

# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" ]]; then
  export TERM=xterm-256color
fi

export TMUX_TMPDIR=/tmp/$USERNAME
mkdir -p $TMUX_TMPDIR

# LOCALE {{{1
# required for bundler to work correctly
# without these it throws "ArgumentError: invalid byte sequence in US-ASCII"
# whenever it finds a gemspec with non-unicode characters
# (see http://ruckus.tumblr.com/post/18613786601/bundler-install-error-argumenterror-invalid-byte)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

# vim: foldmethod=marker
