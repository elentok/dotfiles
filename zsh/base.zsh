# required for bundler to work correctly
# without these it throws "ArgumentError: invalid byte sequence in US-ASCII"
# whenever it finds a gemspec with non-unicode characters
# (see http://ruckus.tumblr.com/post/18613786601/bundler-install-error-argumenterror-invalid-byte)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export VISUAL=vim
export EDITOR=vim

export DOTF=~/.dotfiles
export DOTL=~/.dotlocal

BREW_HOME=/usr/local
if [ -e "$HOME/.homebrew" ]; then
  BREW_HOME=$HOME/.homebrew
elif [ -e "$HOME/.linuxbrew" ]; then
  BREW_HOME=$HOME/.linuxbrew
fi
export BREW_HOME

PATH=$BREW_HOME/bin
PATH=$PATH:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin
PATH=$PATH:$DOTF/scripts:$DOTL/scripts
PATH=$PATH:$HOME/bin:$HOME/scripts
PATH=$PATH:/usr/local/share/npm/bin

# replace bsd binaries with gnu
for pkg in coreutils findutils gnu-sed; do
  gnubin="$BREW_HOME/opt/$pkg/libexec/gnubin"
  if [ -e "$gnubin" ]; then
    PATH=$gnubin:$PATH
  fi
done

export PATH
