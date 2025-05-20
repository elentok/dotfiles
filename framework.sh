#!/usr/bin/env bash
# vim: foldmethod=marker

set -euo pipefail

# DOTF directory {{{1

DOTF="$(dirname "${BASH_SOURCE[0]-$0}")"
DOTF="$(cd "$DOTF" && pwd)"
export DOTF

source "$DOTF/core/bash/core.sh"
source "$DOTF/core/scripts/lib/helpers.sh"
source "$DOTF/core/scripts/lib/ui.sh"
source "$DOTF/core/scripts/lib/fs.sh"
source "$DOTF/core/scripts/lib/node.sh"
source "$DOTF/core/scripts/lib/git.sh"
source "$DOTF/core/scripts/lib/benchmark.sh"

# Machine varibles {{{1
MACHINE_VARFILE=$HOME/.config/machine

if [ -e "$MACHINE_VARFILE" ]; then
  source "$MACHINE_VARFILE"
fi

store_variable() {
  local key="$1"
  local value="$2"

  mkdir -p "$HOME/.config"
  if [ ! -e "$MACHINE_VARFILE" ]; then touch "$MACHINE_VARFILE"; fi

  (
    grep -v "export $key=" "$MACHINE_VARFILE"
    echo "export $key='$(escape_variable "$value")'"
  ) >tmpfile
  mv -f tmpfile "$MACHINE_VARFILE"
  chmod 600 "$MACHINE_VARFILE"

  eval "export $key='$(escape_variable "$value")'"
}

escape_variable() {
  echo -n "$1" | sed "s/'/\\\\'/g"
}

# Git {{{1
git_clone() {
  origin=$1
  target=$2
  option=${3:-}
  dotf-bullet "Cloning $origin => ${target}..."
  if [ -d "$target" ]; then
    if [ -d "$target/.git" ]; then
      current_origin=$(cd "$target" && git_get_origin)
      if [ "$current_origin" == "$origin" ]; then

        if [ "$option" == "--update" ]; then
          dotf-info " already cloned, just updating"
          (cd "$target" && git pull)
        else
          dotf-info " already cloned"
        fi
        return
      fi
    fi
    dotf-backup "$target"
  fi

  git clone "$1" "$2"
}

git_get_origin() {
  git remote -v | grep fetch | awk '{print $2}'
}

# Deb packages {{{1
install_deb() {
  local name="$1"
  local url="$2"

  dotf-bullet "Installing ${name}..."

  if apt_cache | grep "^${name}$" >/dev/null; then
    dotf-info " already installed"
  else
    wget "$url" -O $TMP/${name}.deb
    sudo dpkg -i $TMP/${name}.deb
    rm -f $TMP/apt-cache
  fi
}

# make_dir {{{1
make_dir() {
  dotf-bullet "Creating directory ${1}... "
  if [ -e $1 ]; then
    dotf-info "already exists"
  else
    mkdir -p $1
    if [ $? == 0 ]; then
      dotf-success "created"
    else
      dotf-info "  trying with sudo:"
      sudo mkdir -p $1
      if [ $? != 0 ]; then
        dotf-error "FAILED"
        exit 1
      fi
    fi
  fi
}

# sudo_copy {{{1
sudo_copy() {
  dotf-bullet "Copying $(basename $1) to $2 (with sudo)... "

  if should_sudo_copy "$1" "$2"; then
    if [ -e "$2.backup" ]; then
      sudo mv -f "$2" "$2.backup"
    fi

    sudo cp -f "$1" "$2"
    show_result die_on_error
  else
    dotf-info 'already exists'
  fi
}

should_sudo_copy() {
  if [ ! -e "$2" ]; then
    return 0
  fi

  if diff "$1" "$2" >/dev/null; then
    return 1
  fi

  return 0
}

# copy_to_dir {{{1
copy_to_dir() {
  source="$1"
  target_dir="$2"
  if [[ ! "$target_dir" =~ /$ ]]; then
    target_dir="$target_dir/"
  fi

  if [ ! -d "$target_dir" ]; then
    make_dir "$target_dir"
  fi

  basename="$(basename "$source")"

  dotf-bullet "Copying '$basename' to '$target_dir'... "
  if [ -e "$target_dir$basename" ]; then
    dotf-info 'already exists.'
  else
    cp "$source" "$target_dir"
    if [ $? != 0 ]; then
      dotf-error 'FAILED'
      exit 1
    else
      dotf-success 'done'
    fi
  fi
}

# user {{{1
user_exists() {
  id "$1" >/dev/null 2>&1
}

user_has_group() {
  local group="$1"
  local user="${2:-}"
  if [ -z "$user" ]; then
    user=$(whoami)
  fi

  groups $user | cut -d: -f2 | grep "\b$group\b" >/dev/null
}

add_user_to_group() {
  local group="$1"
  local user="${2:-}"
  if [ -z "$user" ]; then
    user=$(whoami)
  fi

  dotf-bullet "Adding '$user' to group '$group'... "

  if user_has_group $group $user; then
    dotf-info 'already exists.'
  else
    sudo usermod -a -G $group $user
    show_result die_on_error
  fi
}

# group {{{1
group_exists() {
  cat /etc/group | grep "^$1:" >/dev/null 2>&1
}

create_group() {
  local group="$1"

  dotf-bullet "Creating group '$group'... "
  if group_exists "$group"; then
    dotf-info 'already exists.'
  else
    sudo groupadd "$group"
    show_result die_on_error
  fi
}

# extract flag {{{1

# Usage:
#   func() {
#     FLAG1=no
#     FLAG2=no
#     while extract_flag "$1"; do shift; done
#     echo "1=$FLAG1 2=$FLAG2"
#   }
#
# func --flag1          # 1=yes 2=no
# func --flag2          # 1=no 2=yes
# func --flag1 --flag2  # 1=yes 2=yes
# func --flag1=value    # 1=value 2=yes
#
extract_flag() {
  if [[ "$1" =~ ^-- ]]; then
    local flag_name="${1/--/}"
    local value='yes'

    if [[ "$flag_name" =~ "=" ]]; then
      local value="$(echo $flag_name | cut -d= -f2)"
      local flag_name="$(echo $flag_name | cut -d= -f1)"
    fi

    local flag_name="$(dotf-to-uppercase $flag_name)"

    eval "$flag_name=\"$value\""
    return 0
  fi

  return 1
}

# Run command {{{1
#
# Usage:
#   run_command [--sudo] [--bg] <name> <command> <arg1>...
#
run_command() {
  SUDO=no
  BG=no
  while extract_flag "$1"; do shift; done

  name="$1"
  shift

  dotf-bullet "Starting ${name}... "
  if dotf-is-running "$1"; then
    dotf-info 'Already running.'
  else
    cmd='sh -c'
    if [ "$SUDO" == 'yes' ]; then
      cmd='sudoo'
    fi

    if [ "$BG" == 'yes' ]; then
      $cmd "$@" &
      dotf-success '(started in background)'
    else
      $cmd "$@"
      show_result
    fi
  fi
}

# Find parent {{{1

# Looks for a parent directory with one of the following files
# e.g.
#
# root=$(find-parent-with .git Gemfile)
#
function find-parent-with() {
  local path=''
  while [ 1 ]; do
    local abspath=$(
      cd ./$path
      pwd
    )
    if [ "$abspath" == "/" ]; then
      return 1
    fi

    for filename in "$@"; do
      if [ -e "$abspath/$filename" ]; then
        echo "$abspath"
        return 0
      fi
    done

    path="../$path"
  done
}

# helpers {{{1
device-for() {
  local mountpoint="$1"
  diskutil info "$mountpoint" | grep 'Device Node' | cut -d: -f2 | dotf-trim
}

# Services {{{1
service-start() {
  dotf-bullet "Starting service $1... "
  sudo service "$1" start
  show_result
}

service-stop() {
  dotf-bullet "Stopping service $1... "
  sudo service "$1" stop
  show_result
}

# Verify permissions {{{1
verify-perms() {
  local expected="$1"
  local file="$2"

  printf "* Verifying '$file' has permissions '$expected'... "
  if [ ! -e "$file" ]; then
    dotf-info 'skipping, file is missing'
    return
  fi

  local actual="$(stat --format=%a $file)"
  if [ "$actual" == "$expected" ]; then
    dotf-info 'ok'
  else
    ${CHMOD:-chmod} $expected "$file"
    show_result
  fi
}

# Versions {{{1
function is-valid-version() {
  local range="$1"
  local version="$2"
  [ -n "$(semver --coerce --range "$range" "$version")" ]
}

# App Builder {{{1
function app-prepare-build-dir() {
  local name="$1"
  prepare-directory "$TMP/build/$name"
}

function app-prepare-dir() {
  local name="$1"
  local version="$2"
  prepare-directory "$HOME/.apps/all/$name/$version"
}

function prepare-directory() {
  local dir="$1"

  if [ -e "$dir" ]; then
    if [ "${CLEAN:-}" == "no" ]; then
      return
    fi

    rm -rf "$dir"
  fi

  mkdir -p "$dir"

  echo -n "$dir"
}

function app-exists() {
  [ -e "$(app-dir "$@")" ]
}

function app-dir() {
  local name="$1"
  local version="$2"
  echo -n "$HOME/.apps/all/$name/$version"
}

function app-set-default() {
  local name="$1"
  local version="$2"
  target="$(app-dir "$name" default)"
  source="$(app-dir "$name" "$version")"
  if [ ! -e "$source" ]; then
    echo "Error: no directory '${source}'"
    return 1
  fi

  dotf-symlink "$source" "$target"
}
