# VI bindings
bindkey -v

bindkey '^R' history-incremental-search-backward
bindkey '^N' down-line-or-search
bindkey '^K' kill-line
bindkey '^P' up-line-or-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line


# don't log to history commands starting with a space
setopt HIST_IGNORE_SPACE
