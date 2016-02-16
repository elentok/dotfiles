# vim: foldmethod=marker

if [ -e ~/.config/machine ]; then
  source ~/.config/machine
fi

# Android {{{1
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/build-tools/23.0.0

# Completions {{{1
fpath=($BREW_HOME/lib/node_modules/tailr/completions $fpath)
fpath=(/usr/local/share/npm/lib/node_modules/tailr/completions $fpath)
fpath=(/usr/local/share/npm/lib/node_modules/dns-switcher/completions $fpath)
fpath=($HOME/.rbenv/versions/2.0.0-p247/lib/ruby/gems/2.0.0/gems/shaft-0.8.8/completions $fpath)
fpath=($DOTF/zsh/vendor/zsh-completions/src $fpath)

# Pebble {{{1
export PEBBLE_SDKS="$HOME/Library/Application Support/Pebble SDK/SDKs"
export PEBBLE_SDK_VERSION='3.8.2'
export PEBBLE_SDK_DEVICE='basalt'
export PEBBLE_INCLUDE="$PEBBLE_SDKS/$PEBBLE_SDK_VERSION/sdk-core/pebble/$PEBBLE_SDK_DEVICE/include"
export CPATH="$PEBBLE_INCLUDE"

# 3rd party {{{1

cached_eval rbenv rbenv init --no-rehash -

cached_eval fasd fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install \
  zsh-wcomp zsh-wcomp-install

# Mac Specific {{{1

if is_mac; then
  export NVIM_TUI_ENABLE_CURSOR_SHAPE=1
fi

# History {{{1
HISTFILE="$HOME/.zhistory" # The path to the history file.
HISTSIZE=10000                   # The maximum number of events to save in the internal history.
SAVEHIST=10000                   # The maximum number of events to save in the history file.
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ':start:elapsed;command' format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire a duplicate event first when trimming history.
setopt HIST_IGNORE_DUPS          # Do not record an event that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete an old recorded event if a new event is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a previously found event.
setopt HIST_IGNORE_SPACE         # Do not record an event starting with a space.
setopt HIST_SAVE_NO_DUPS         # Do not write a duplicate event to the history file.
setopt HIST_VERIFY               # Do not execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing non-existent history.

# Smart URLs {{{1

# Replace '?', '=' and '&' with \?, \=, \& when typing urls
autoload -Uz url-quote-magic
zle -N self-insert url-quote-magic

# Functions {{{1

function encrypt() {
  openssl des3 -salt -in $* -out $*.secret
}

function decrypt() {
  openssl des3 -salt -d -in $* -out $*.plain
}

function j() {
  cd "$(fasd -l -d "$@" | fzf -1 --no-sort --tac)"
}

function ff {
  find . -iname "*$**"
}

function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

# Bindings {{{1

# VI bindings
bindkey -v

bindkey '^R' history-incremental-pattern-search-backward
bindkey '^F' history-incremental-pattern-search-forward
bindkey '^N' down-line-or-search
bindkey '^K' kill-line
bindkey '^P' up-line-or-search
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Directories {{{1
setopt AUTO_CD              # Auto changes to a directory without typing cd.
setopt AUTO_PUSHD           # Push the old directory onto the stack on cd.
setopt PUSHD_IGNORE_DUPS    # Do not store duplicates in the stack.
setopt PUSHD_SILENT         # Do not print the directory stack after pushd or popd.
setopt PUSHD_TO_HOME        # Push to home directory when no argument is given.
setopt CDABLE_VARS          # Change directory to a path stored in a variable.
setopt AUTO_NAME_DIRS       # Auto add variable-stored paths to ~ list.
setopt MULTIOS              # Write to multiple descriptors.
setopt EXTENDED_GLOB        # Use extended globbing syntax.
unsetopt CLOBBER            # Do not overwrite existing files with > and >>.
                            # Use >! and >>! to bypass.

# FZF {{{1

# make FZF respect .gitignore
export FZF_DEFAULT_COMMAND='ag -g ""'

# Misc {{{1

# don't log to history commands starting with a space
setopt HIST_IGNORE_SPACE
source $DOTF/vim/colors/base16-elentok.dark.sh

export MPD_HOST=$MPD_PASSWORD@localhost
export GREP_OPTIONS=

setopt RC_QUOTES          # Allow 'Henry''s Garage' instead of 'Henry'\''s Garage'.
setopt LONG_LIST_JOBS     # List jobs in the long format by default.
setopt AUTO_RESUME        # Attempt to resume existing job before creating a new process.
setopt NOTIFY             # Report status of background jobs immediately.
unsetopt BG_NICE          # Don't run all background jobs at a lower priority.
unsetopt HUP              # Don't kill jobs on shell exit.
unsetopt CHECK_JOBS       # Don't report on jobs when shell exit.
