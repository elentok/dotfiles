# vim: foldmethod=marker

if is_mac; then
  unalias s
elif is_wsl; then
  alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/code.exe'
fi

# All Aliases {{{1
alias ..='cd ..'
alias ba='bt add-magnet "$(pbp)"'
alias bdr='bin/docker/run'
alias bdb='bin/docker/build'
alias be='bundle exec'
alias bl='tr ":" "\n"'
alias bytes='stat --format=%s'
alias c1='awk "{ print \$1 }"'
alias c2='awk "{ print \$2 }"'
alias c3='awk "{ print \$3 }"'
alias c4='awk "{ print \$4 }"'
alias c5='awk "{ print \$5 }"'
alias c6='awk "{ print \$6 }"'
alias c='clip copy'
alias C=calc
alias cl=clear
alias cdr='cd "$(find-root)"'
alias cf='/bin/ls -1 | wc -l' # count files
alias df='df -kh'
alias doc='docker-compose'
alias dorit='docker run --rm -it'
alias dotfi='cd $DOTF'
alias dotl='cd $DOTL'
alias du='du -kh'
alias eslint-debug='DEBUG=eslint:cli-engine eslint'
alias fliph='convert -flop'
alias flipv='convert -flip'
alias g='git'
alias gp='cd $(list-projects | fzf | sed "s#~#$HOME#")'
alias gcoo='git all-branches | fzf | xargs git checkout'
alias gdestroy='git destroy `git all-branches | fzf`'
alias gsp='gsutil acl ch -u AllUsers:R'
alias hex='od -xcb'
alias hh='history'
alias most-used-commands="history 0 | awk '{print \$2}' | sort | uniq -c | sort -n -r | head"
alias k='less $DOTF/docs/keys.md'
alias kb='xkeyboard'
alias ke='vim $DOTF/docs/keys.md'
alias kk='kill `ps aux | fzf | awk ''{print $2 }''`'
alias ls='command ls --color=always -XFhs'
alias lss='command ls -1 -s'
alias mod='stat --format=%a'
alias ngx='sudoo nginx -s reload'
alias nv='nvim'
alias npd='npm run dev'
alias p='clip paste'
alias pio='platformio'
alias pk='pkgs track'
alias psg='ps -a -x -o user,pid,command | grep'
alias pth='echo $PATH | tr ":" "\n"'
alias pss='pacman -Ss'
alias psi='sudo pacman -S'
alias qless='less --chop-long-lines --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias rr='ranger'
alias rgf='noglob rg --files -g'
alias ssh='TERM=$SSH_TERM ssh'
alias summ='awk "{ s+=\$1 } END { print s }"'
alias sub='subliminal download -l en -s'
alias tm='DISPLAY=${DISPLAY:-:0} tmux -u'
alias tma='tm a'
alias tot='awk "{ s+=\$1 } END { printf(\"%''d\n\", s) }"'
alias total='awk "{ s+=\$1 } END { print s }"'
alias ts='tig status'
alias vz='file="$(edit-zsh-dotfile)" && source $file'
alias x=exit
alias ports='sudo echo && (sudo lsof -i -n -P | fzf --header-lines=1)'

alias ew='whichx $EDITOR'
alias cw='whichx cat'

# Neovim {{{1
if has_command nvim; then
  if is_in_neovim; then
    alias vi='nvr -o'
    alias vv='nvr -O'

    function nvim-set-workdir() {
      nvr --remote-send "<c-\><c-n>:call TermSetWorkDir('$PWD')<cr>i"
    }

    function cd() {
      builtin cd "$@"
      nvim-set-workdir
    }
  else
    alias vi=nvim
  fi
else
  alias vi=vim
fi
alias vcd='nvr --remote-send "<c-\><c-n>:tcd $PWD<cr>i"'
alias vl='vim "+OpenSession! last"'

# Confirm filesystem operations {{{1
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# iOS Simulator {{{1
alias iosroot='cd `ios root`'
function iosapp() {
  cd "$(ios app-root "$*")"
}

# Mac/Linux {{{1
if is_mac; then
  alias hda='hdiutil attach'
  alias hdd='hdiutil detach'
  alias hdi='hdiutil info'
elif is_wsl; then
  alias pbpaste='win32yank -o'
  alias pbcopy='win32yank -i'
else
  alias pbpaste='xclip -selection clipboard -out'

  if has_command xclip; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif has_command xsel; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'


# FZF Shortcuts {{{1
dr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    docker-compose run $@
    return $?
  fi

  cmd="$(docker-compose-services | fzf --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "docker-compose run $cmd" && \
      echo "> docker-compose run $cmd" && \
      docker-compose run $cmd
  fi
}

yr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    yarn run $@
    exit $?
  fi

  cmd="$(npm-scripts | fzf --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "yarn run $cmd" && \
      echo "> yarn run $cmd" && \
      yarn run $cmd
  fi
}

npr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    npm run $@
    exit $?
  fi

  cmd="$(npm-scripts | fzf --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "npm run $cmd" && \
      echo "> npm run $cmd" && \
      npm run $cmd
  fi
}

t() {
  log="$(tailr --list | tr " " "\n" | fzf --exit-0)"
  if [ -n "$log" ]; then
    echo "Tailing $log..."
    print -s "tailr $log"
    tailr $log
  fi
}

ss() {
  server="$(pick-ssh-server)"
  if [ -n "$server" ]; then
    echo "Connecting to $server..."
    print -s "ssh $server"
    ssh $server
  fi
}

capd() {
  stage="$(cd config/capistrano/stages && /bin/ls -1 | sed 's/.rb//' | fzf --exit-0)"
  if [ -n "$stage" ]; then
    echo "Deploying to $stage..."
    print -s "be cap $stage deploy"
    bundle exec cap $stage deploy
  fi
}

de() {
  local file="$(cd $DOTF && ag -l --ignore 'zsh/vendor' | fzf --exit-0)"
  if [ -n "$file" ]; then
    print -s "$EDITOR $file"
    $EDITOR $DOTF/$file
  fi
}

cdd() {
  local dir="$(dff | fzf --ansi --exit-0 | awk '{print $6}')"
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}

vp() {
  local plugin="$(cd $HOME/.vim/plugged && /bin/ls -1 | fzf --ansi --exit-0)"
  if [ -n "$plugin" ]; then
    cd "$HOME/.vim/plugged/$plugin"
  fi
}

# DOTLOCAL {{{1
source_if_exists "$DOTL/zsh/aliases.sh"
