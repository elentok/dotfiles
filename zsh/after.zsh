# SSH {{{1
export SSH_TERM=xterm

if [ -n "$TMUX" ]; then
  export SSH_AUTH_SOCK="$HOME/.ssh/default-agent"
  agent fix
fi

# Aliases {{{1

alias agg="ag --ignore '*.yml'"
alias be='bundle exec'
alias bl='tr ":" "\n"'
alias c1='awk "{ print \$1 }"'
alias c2='awk "{ print \$2 }"'
alias c3='awk "{ print \$3 }"'
alias c4='awk "{ print \$4 }"'
alias c5='awk "{ print \$5 }"'
alias c6='awk "{ print \$6 }"'
alias c=clear
alias cd/='cd "$(find-root)"'
alias cf='/bin/ls -1 | wc -l' # count files
alias dotfi='cd $DOTF'
alias dotl='cd $DOTL'
alias fliph='convert -flop'
alias flipv='convert -flip'
alias gcoo='git all-branches | selecta | xargs git checkout'
alias gdestroy='git destroy `git all-branches | selecta`'
alias gulp='gulp --require coffee-script/register'
alias hex='od -xcb'
alias hh='history'
alias i18n='bin/rake i18n:js:export'
alias k='less $DOTF/docs/keys.md'
alias ke='vim $DOTF/docs/keys.md'
alias kk='kill `ps aux | selecta | awk ''{print $2 }''`'
alias ls='ls --color=always -XFhs'
alias m=ncmpcpp
alias ma='mpc add'
alias mcl='mpc clear'
alias mf='mpc search filename'
alias mn='mpc next'
alias mt='mpc toggle'
alias nv='nvim'
alias pdr='powder restart'
alias pio='platformio'
alias pix='open -a Pixelmator'
alias psg='ps -a -x -o user,pid,command | grep'
alias pth='echo $PATH | tr ":" "\n"'
alias q='qlmanage -p'
alias rbr='rbenv rehash'
alias rrr='bin/rake tmp:clear; bin/rake assets:clean'
alias ssh='TERM=$SSH_TERM ssh'
alias t='tailr `tailr --list | tr " " "\n" | selecta`'
alias tm='tmux -u'
alias tma='tm a'
alias tot='awk "{ s+=\$1 } END { printf(\"%''d\n\", s) }"'
alias total='awk "{ s+=\$1 } END { print s }"'
alias ts='tig status'
alias v=vim
alias vl='vim "+OpenSession! last"'
alias x=exit
alias vz='file="$(edit-zsh-dotfile)" && source $file'

if [[ "`uname -s`" == "Darwin" ]]; then

else
  alias cl='xclip -selection clipboard -o'
  alias st='scrot -s'
  alias wp='feh --bg-fill'
fi

# Functions {{{1

function encrypt() {
  openssl des3 -salt -in $* -out $*.secret
}

function decrypt() {
  openssl des3 -salt -d -in $* -out $*.plain
}

ff() {
  find . -iname "*$**"
}

# Settings: Bindings {{{1

# VI bindings
bindkey -v

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^F' history-incremental-pattern-search-forward
bindkey '^N' down-line-or-search
bindkey '^K' kill-line
bindkey '^P' up-line-or-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Settings: Misc {{{1

# don't log to history commands starting with a space
setopt HIST_IGNORE_SPACE
source $DOTF/vim/colors/base16-elentok.dark.sh

export MPD_HOST=bob@localhost
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
export GREP_OPTIONS=

# vim: foldmethod=marker
