# vim: foldmethod=marker

# Zsh completion {{{1
autoload -U compinit && compinit

# Use caching to make completion for cammands such as dpkg and apt usable.
zstyle ':completion::complete:*' use-cache on
zstyle ':completion::complete:*' cache-path "$HOME/.local/share/zcompcache"

# Case-insensitive (all), partial-word, and then substring completion.
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
unsetopt CASE_GLOB

# Group matches and describe.
zstyle ':completion:*:*:*:*:*' menu select
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes

# FZF Completion: capistrano {{{1
_fzf_complete_bec() {
  _fzf_complete "" "$@" < <(
    if [ "$(echo $@ | wc -w)" = "1" ]; then
      __cap-complete-stage
    else
      __cap-complete-action
    fi
  )
}

__cap-complete-stage() {
  if [ -e 'config/capistrano/stages' ]; then
    /bin/ls -1 config/capistrano/stages | sed 's/\.rb//'
  fi
}

__cap-complete-action() {
  if [ ! -e .capistrano-cache ]; then
    be cap -T | grep '^cap ' | sed 's/^cap //' > .capistrano-cache
  fi

  cat .capistrano-cache
}

_fzf_complete_bec_post() {
  awk '{print $1}'
}

# FZF Completion: npm {{{1
alias nr="npm run"

_fzf_complete_nr() {
  _fzf_complete "" "$@" < <(
    _npm_list_scripts
  )
}

_npm_list_scripts() {
  node -e 'const s = require("./package.json").scripts; Object.keys(s).forEach(key => { console.log(`${key}: ${s[key]}`) })'
}

_fzf_complete_nr_post() {
  IFS=": " awk '{print $1}' | sed 's/:$//'
}
