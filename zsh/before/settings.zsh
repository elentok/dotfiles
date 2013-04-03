# required for bundler to work correctly
# without these it throws "ArgumentError: invalid byte sequence in US-ASCII"
# whenever it finds a gemspec with non-unicode characters
# (see http://ruckus.tumblr.com/post/18613786601/bundler-install-error-argumenterror-invalid-byte)
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8

export EDITOR=vim

export DOTF=~/.dotfiles

PATH=/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin
PATH=$PATH:$HOME/.rvm/bin:$DOTF/scripts
PATH=$PATH:$HOME/bin:$HOME/projects/railsnew:$HOME/scripts
PATH=$PATH:/usr/local/share/python
PATH=/usr/local/share/npm/bin:$PATH
PATH=$PATH:$GOBIN
export PATH

export MPD_HOST=bob@localhost
export SHORT_HOSTNAME=`short-hostname`
export GOROOT=/usr/local/Cellar/go/1.0.3
export GOBIN=$GOROOT/bin

[[ -s /Users/3david/.nvm/nvm.sh ]] && . /Users/3david/.nvm/nvm.sh # This loads NVM

# so tmux will allow 256 colors:
if [[ "$TERM" != "screen-256color" ]]; then
  export TERM=xterm-256color
fi

fpath=(/usr/local/share/npm/lib/node_modules/tailr/completions $fpath)
fpath=(/usr/local/share/npm/lib/node_modules/dns-switcher/completions $fpath)
fpath=(/Users/3david/.rvm/gems/ruby-2.0.0-p0/gems/shaft-0.8/completions $fpath)

zstyle ':presto:load' pmodule 'git'

