# VI bindings
bindkey -v

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^F' history-incremental-pattern-search-forward
bindkey '^N' down-line-or-search
bindkey '^K' kill-line
bindkey '^P' up-line-or-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line


# don't log to history commands starting with a space
setopt HIST_IGNORE_SPACE

source $DOTF/vim/colors/base16-elentok.dark.sh

export MPD_HOST=bob@localhost

# neovim
export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
