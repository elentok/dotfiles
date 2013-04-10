alias m=ncmpcpp
alias x=exit
alias mf='mpc search filename'
alias ma='mpc add'
alias mp='mpc play'
alias mcl='mpc clear'
alias sr='screen -R'
alias ak='ssh-add ~/.keys/bitbucket.ssh.private'
alias cl='xclip -selection clipboard -o'
alias ft="ruby ~/projects/tvutils/bin/filestube.rb -s filesonic"
alias sub="ruby ~/projects/tvutils/bin/download_subtitles.rb"
alias clean="ruby ~/projects/tvutils/bin/clean.rb"
alias st='scrot -s'
alias dotf='cd $DOTF'
alias rr='source ~/.config/dotfiles/scripts/init-rvm'
alias mac='ruby ~/projects/macrumors/macrumors.rb'
alias wp='feh --bg-fill'
alias pryy='pry -r ./config/environment'
alias trailer='wget -U QuickTime'
alias txt='cd ~/Dropbox/PlainText && vim'
alias psg='ps aux | grep'

if [[ "`uname -s`" == "Darwin" ]]; then
  alias ls='ls -FGsk'
  # s = show size
  # k = show size in kilobytes
  alias ackc='ack --coffee'
else
  alias ack='ack-grep'
  alias ackc='ack-grep --coffee'
  alias ls='ls --color=always -XFhs'
fi

alias wip='cucumber --drb --profile wip'
alias cuc='cucumber --drb'
alias tigs='tig status'
alias ts='tig status'
alias z='zeus'
alias t='tmux -u'
alias k='less $DOTF/docs/keys.md'
alias kk='vim $DOTF/docs/keys.md'
alias q='qlmanage -p'
alias vimt='vim ~/Dropbox/vim.TODO'
alias tailog='tail -f log/development.log | cat -v'
alias cf='/bin/ls -1 | wc -l'
alias bw='convert -colors 2'

alias va='vim $DOTF/zsh/after/aliases.zsh'
alias ff='find . -iname'

alias c1='awk "{ print \$1 }"'
alias c2='awk "{ print \$2 }"'
alias c3='awk "{ print \$3 }"'
alias c4='awk "{ print \$4 }"'
alias c5='awk "{ print \$5 }"'
alias c6='awk "{ print \$6 }"'

alias total='awk "{ s+=\$1 } END { print s }"'
alias tot='awk "{ s+=\$1 } END { printf(\"%''d\n\", s) }"'

alias n='env NODE_NO_READLINE=1 rlwrap -p Green -S "node >>> " node'

alias gca='git commit --amend'
alias gs='git status'
alias gst='git status'
