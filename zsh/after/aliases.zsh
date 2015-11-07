export SSH_TERM=xterm

alias agg="ag --ignore '*.yml'"
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
alias pio='platformio'
alias pix='open -a Pixelmator'
alias psg='ps -a -x -o user,pid,command | grep'
alias q='qlmanage -p'
alias rbr='rbenv rehash'
alias ssh='TERM=$SSH_TERM ssh'
alias t='tailr `tailr --list | tr " " "\n" | selecta`'
alias tm='tmux -u'
alias tma='tm a'
alias tot='awk "{ s+=\$1 } END { printf(\"%''d\n\", s) }"'
alias total='awk "{ s+=\$1 } END { print s }"'
alias ts='tig status'
alias v=vim
alias va='vim $DOTF/zsh/after/aliases.zsh; source $DOTF/zsh/after/aliases.zsh'
alias vl='vim "+OpenSession! last"'
alias x=exit
alias pth='echo $PATH | tr ":" "\n"'

function encrypt() {
  openssl des3 -salt -in $* -out $*.secret
}

function decrypt() {
  openssl des3 -salt -d -in $* -out $*.plain
}

ff() {
  find . -iname "*$**"
}

if [[ "`uname -s`" == "Darwin" ]]; then

else
  alias cl='xclip -selection clipboard -o'
  alias st='scrot -s'
  alias wp='feh --bg-fill'
fi
