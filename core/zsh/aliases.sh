#!/usr/bin/env bash
# vim: foldmethod=marker

source "$DOTF/core/nvim/aliases.sh"

if dotf-is-wsl; then
  alias code='/mnt/c/Program\ Files/Microsoft\ VS\ Code/code.exe'
fi

# All Aliases {{{1
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias bl='tr ":" "\n"'
alias bytes='stat --format=%s'
alias y='dotf-clipboard copy'
alias C=calc
alias cl=clear
alias cdr='cd "$(git-root)"'
alias cf='/bin/ls -1 | wc -l' # count files
alias df='df -kh'
alias doc='docker-compose'
alias dorit='docker run --rm -it'
alias dotfi='cd $DOTF'
alias dotp='cd $DOTP && cd "$(command ls -1 | fzf-tmux -p --select-1)"'
alias du='du -kh'
alias fliph='convert -flop'
alias flipv='convert -flip'
alias g='git'
alias gcoo='git all-branches | fzf-tmux -p | xargs git checkout'
alias gdestroy='git destroy `git all-branches | fzf-tmux -p`'
alias gsp='gsutil acl ch -u AllUsers:R'
alias hex='od -xcb'
alias hh='history'
alias k='less $DOTF/docs/keys.md'
alias kb='xkeyboard'
alias ke='vim $DOTF/docs/keys.md'
alias lg='lazygit'
alias ll='exa --group-directories-first -F --long --grid --time-style=long-iso --git'
alias ls='command ls --color=always -XFhs --group-directories-first --time-style=long-iso'
alias lss='command ls -1 -s'
alias m='hgi'
alias mod='stat --format=%a'
alias o='dotf-open'
alias p='dotf-clipboard paste'
alias ipy='ipython3'
alias psg='ps -a -x -o user,pid,command | grep'
alias pth='echo $PATH | tr ":" "\n"'
alias qless='less --chop-long-lines --RAW-CONTROL-CHARS --quit-if-one-screen --no-init'
alias rgf='noglob rg --files -g'
alias rqs='dotf-repos quick-status'
alias sub='subliminal download -l en -s'
alias se='sudoedit'
alias ts='tig status'
alias q='qalc'
if dotf-is-mac; then
  # For some reason tig on mac looks wierd inside tmux.
  alias tig='TERM=xterm-256color tig'
  alias ts='TERM=xterm-256color tig status'
fi
alias vz='file="$(edit-zsh-dotfile)" && source $file'
alias vg='vi -c "G | WinOnly"'
alias x=exit
alias ports='sudo echo && (sudo lsof -i -n -P | fzf --header-lines=1)'

alias ew='whichx $EDITOR'
alias cw='whichx cat'

# SSH {{{1
function ssh() {
  dotf-term-title "SSH $*"
  TERM=$SSH_TERM command ssh "$@"
  exitcode=$?
  dotf-term-title
  return $exitcode
}

# Awk {{{1
function col1() { awk '{ print $1 }'; }
function col2() { awk '{ print $2 }'; }
function col3() { awk '{ print $3 }'; }
function col4() { awk '{ print $4 }'; }
function col5() { awk '{ print $5 }'; }
function col6() { awk '{ print $6 }'; }

function total() {
  awk '{ s+=$1 } END { print s }'
}

# Misc Functions {{{1
function most-used-commands() {
  history 0 | awk '{print $2}' | sort | uniq -c | sort -n -r | head
}

function kk() {
  pid="$(ps aux | fzf | awk '{print $2 }')"
  if [ -n "$pid" ]; then
    kill "$@" "$pid"
  fi
}

# Neovim {{{1

alias vcd='nvr --remote-send "<c-\><c-n>:tcd $PWD<cr>i"'
alias vl='vim "+OpenSession! last"'

# Confirm filesystem operations {{{1
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Mac/Linux {{{1
if dotf-is-mac; then
  alias hda='hdiutil attach'
  alias hdd='hdiutil detach'
  alias hdi='hdiutil info'
elif dotf-is-wsl; then
  alias pbpaste='win32yank -o'
  alias pbcopy='win32yank -i'
else
  alias pbpaste='xclip -selection clipboard -out'

  if dotf-has-command xclip; then
    alias pbcopy='xclip -selection clipboard -in'
    alias pbpaste='xclip -selection clipboard -out'
  elif dotf-has-command xsel; then
    alias pbcopy='xsel --clipboard --input'
    alias pbpaste='xsel --clipboard --output'
  fi
fi

alias pbc='pbcopy'
alias pbp='pbpaste'

# Jump to {{{1

alias jw='cd $(git-wt pick || pwd)'
alias jp='cd $(dotf-projects pick || pwd)'
alias jy='cd $(yarn-pkgs pick || pwd)'

# FZF Shortcuts {{{1

dr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    docker-compose run "$@"
    return $?
  fi

  cmd="$(docker-compose-services | fzf --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "docker-compose run $cmd" \
      && echo "> docker-compose run $cmd" \
      && docker-compose run "$cmd"
  fi
}

yr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    yarn run "$@"
    return $?
  fi

  cmd="$(npm-scripts | fzf-tmux -p --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "yarn run $cmd" \
      && echo "> yarn run $cmd" \
      && yarn run "$cmd"
  fi
}

yt() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    yarn test "$@"
    return $?
  fi

  file="$(fd .test. | zf | awk '{print $1}')"

  if [ -n "$file" ]; then
    print -s "yarn test $file" \
      && echo "> yarn test $file" \
      && yarn test "$file"
  fi
}


npr() {
  # calling "print -s" adds the command to zsh history

  if [ $# -gt 0 ]; then
    npm run "$@"
    return $?
  fi

  cmd="$(npm-scripts | fzf-tmux -p --ansi --exit-0 | awk '{print $1}')"

  if [ -n "$cmd" ]; then
    print -s "npm run $cmd" \
      && echo "> npm run $cmd" \
      && npm run "$cmd"
  fi
}

ss() {
  server="$(pick-ssh-server)"
  if [ -n "$server" ]; then
    echo "Connecting to $server..."
    print -s "ssh $server"
    ssh "$server"
  fi
}

de() {
  file="$(cd "$DOTF" && rg -l --ignore 'zsh/vendor' | fzf --exit-0)"
  if [ -n "$file" ]; then
    print -s "$EDITOR $file"
    $EDITOR "$DOTF/$file"
  fi
}

cdd() {
  dir="$(dff | fzf-tmux -p --ansi --exit-0 | awk '{print $6}')"
  if [ -n "$dir" ]; then
    cd "$dir" || return 1
  fi
}

f() {
  if [ $# -eq 0 ]; then
    TERM=xterm-256color vifm .
  else
    TERM=xterm-256color vifm "$@"
  fi
}

# Fuzzy cd {{{1

alias c='cd "$(pick-directory-recursive)"'
alias d='cd "$(pick-directory)"'

function pick-directory() {
  # calling "print -s" adds the command to zsh history

  dir="$(list-dirs -maxdepth 6 | fzf --ansi --exit-0 --select-1)"

  if [ -n "$dir" ]; then
    print -s "cd ""$dir""" && echo "$dir"
  else
    echo .
  fi
}

function pick-directory-recursive() {
  full_dir="."

  dir="$(list-dirs | fzf-tmux -p --ansi --exit-0)"
  while [ -n "$dir" ]; do
    full_dir="$full_dir/$dir"
    dir="$(list-dirs "$full_dir" | fzf-tmux -p --ansi --exit-0)"
  done

  if [ -n "$full_dir" ]; then
    print -s "cd ""$full_dir""" && echo "$full_dir"
  else
    echo .
  fi
}

# Usage: list-dirs [optional: root]
function list-dirs() {
  max_depth=1

  if [ "${1:-}" = "-maxdepth" ]; then
    max_depth="$2"
    shift
    shift
  fi

  if [ $# -gt 0 ]; then
    root="$1"
  else
    root="$(pwd)"
  fi

  (cd "$root" && find . -maxdepth $max_depth -type d) | sed 's#^\.\/##' | grep -v '^\.$' || true
}

# Tmux {{{1

# If a tmux session exists, attach to it, otherwise create a new one.
function tm() {
  if [ -n "${TMUX:-}" ]; then
    echo "Error: already inside a tmux session!"
  elif [ -n "$(tmux list-sessions 2> /dev/null)" ]; then
    echo "Attaching to existing tmux session..."
    tmux attach
  else
    echo "No existing tmux session found, creating new session..."
    tmux -u
  fi
}

# Plugins {{{1
for file in "$DOTP"/*/zsh/aliases.sh(N); do
  source "$file"
done
