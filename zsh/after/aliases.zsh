alias x=exit
alias c=clear

# Tmux {{{1
alias tm='tmux -u'
alias tma='tm a'

# Todo.txt {{{1
t() { vim "+Todo $*" }
alias tl='t ls'
alias tt='todo.sh -t -d $DOTF/todo/todo.cfg'

# Vim {{{1
alias v=vim
alias vl='vim "+OpenSession! last"'
alias va='vim $DOTF/zsh/after/aliases.zsh; source $DOTF/zsh/after/aliases.zsh'
alias txt='cd ~/Dropbox/PlainText && vim'
alias vimt='vim ~/Dropbox/vim.TODO'

# Find {{{1
ff() {
  find . -iname "*$**"
}
alias agg="ag --ignore '*.yml'"

# Mac Specific {{{1
if [[ "`uname -s`" == "Darwin" ]]; then
  #alias ls='ls -FGsk'
  alias ls='$BREW_HOME/bin/gls --color=always -XFhs'
  # s = show size
  # k = show size in kilobytes

# Linux Specific {{{1
else
  alias ls='ls --color=always -XFhs'
  alias cl='xclip -selection clipboard -o'
  alias st='scrot -s'
  alias wp='feh --bg-fill'

fi

# mpc {{{1
alias m=ncmpcpp
alias mf='mpc search filename'
alias ma='mpc add'
alias mn='mpc next'
alias mp='mpc toggle'
alias mcl='mpc clear'
# 2}}}

# Helpers {{{1

alias c1='awk "{ print \$1 }"'
alias c2='awk "{ print \$2 }"'
alias c3='awk "{ print \$3 }"'
alias c4='awk "{ print \$4 }"'
alias c5='awk "{ print \$5 }"'
alias c6='awk "{ print \$6 }"'

alias total='awk "{ s+=\$1 } END { print s }"'
alias tot='awk "{ s+=\$1 } END { printf(\"%''d\n\", s) }"'

# SSH {{{1
export SSH_TERM=xterm
alias ssh='TERM=$SSH_TERM ssh'
alias t='tailr `tailr --list | tr " " "\n" | selecta`'

# Other {{{1
alias bw='convert -colors 2'
alias cf='/bin/ls -1 | wc -l' # count files
alias dotfi='cd $DOTF'
alias dotl='cd $DOTL'
alias k='less $DOTF/docs/keys.md'
alias ke='vim $DOTF/docs/keys.md'
alias n='env NODE_NO_READLINE=1 rlwrap -p Green -S "node >>> " node'
alias pryy='pry -r ./config/environment'
alias psg='ps aux | grep'
alias q='qlmanage -p'
alias trailer='wget -U QuickTime'
alias z='zeus'
alias hh='history'
alias hex='od -xcb'
alias pix='open -a Pixelmator'
alias rbr='rbenv rehash'
alias gulp='gulp --require coffee-script/register'
alias pio='platformio'
alias nv='nvim'
alias ts='tig status'
alias cd/='cd "$(find-root)"'

alias fliph='convert -flop'
alias flipv='convert -flip'

function encrypt() {
  openssl des3 -salt -in $* -out $*.secret
}

function decrypt() {
  openssl des3 -salt -d -in $* -out $*.plain
}

# Selecta {{{1
alias kk='kill `ps aux | selecta | awk ''{print $2 }''`'
alias gcoo='git all-branches | selecta | xargs git checkout'
alias gdestroy='git destroy `git all-branches | selecta`'

# Pomo {{{1
alias p='pomo'
alias pi='pomo interactive'
alias pom='pomo stats'

# vim: foldmethod=marker
