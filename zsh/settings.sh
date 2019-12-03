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

if has_command rbenv; then
  with_cache rbenv source rbenv init --no-rehash -
fi

if has_command fasd; then
  if is_zsh; then
    with_cache fasd source fasd --init posix-alias zsh-hook zsh-ccomp zsh-ccomp-install \
      zsh-wcomp zsh-wcomp-install
  fi
fi
# Mac Specific {{{1




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

if has_command rg; then
  function ff {
    if [ $# -eq 0 ]; then
      rg --files
    else
      rg --files --iglob "*$**"
    fi
  }
else
  function ff {
    find . -iname "*$**"
  }
fi


function find-exec {
  find . -type f -iname "*${1:-}*" -exec "${2:-file}" '{}' \;
}

function videos() {
  ag '.' -l --nocolor -g '(mkv|avi|mp4)'
}

function pl() {
  local filename="$(videos | fzf)"
  if [ -n "$filename" ]; then
    open "$filename"
  fi
}

if is_wsl; then
  function open() {
    explorer.exe "$@"
  }
elif is_linux; then
  function open() {
    xdg-open "$@"
  }
fi

# FZF {{{1

# make FZF respect .gitignore
# export FZF_DEFAULT_COMMAND='ag -g ""'
export FZF_DEFAULT_COMMAND='rg --files --hidden --follow -g "!{.git,node_modules}/*" 2> /dev/null'

# https://github.com/junegunn/fzf/issues/809
[ -n "${NVIM_LISTEN_ADDRESS:-}" ] && export FZF_DEFAULT_OPTS='--no-height'

# SSH {{{1
export SSH_AUTH_SOCK="$HOME/.ssh/active-agent"
agent setup > /dev/null

# GCloud SDK {{{1

gcloud_path="$HOME/google-cloud-sdk"

if [ -e "$gcloud_path" ]; then
  # The next line updates PATH for the Google Cloud SDK.
  source "$gcloud_path/path.zsh.inc"

  # The next line enables shell command completion for gcloud.
  # Disabling this for now, it seems to cause some sort of delay on OSX
  # source "$gcloud_path/completion.zsh.inc"
fi

