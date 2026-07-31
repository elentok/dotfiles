#!/usr/bin/env bash
#
# User/group management helpers used by component installers that need to
# create system users/groups (dfl has no equivalent primitive for these).

user_exists() {
  id "$1" >/dev/null 2>&1
}

group_exists() {
  grep "^$1:" /etc/group >/dev/null 2>&1
}

user_has_group() {
  local group="$1"
  local user="${2:-}"
  if [ -z "$user" ]; then
    user=$(whoami)
  fi

  groups "$user" | cut -d: -f2 | grep "\b$group\b" >/dev/null
}

create_group() {
  local group="$1"

  dfl step start "Creating group '$group'..."
  if group_exists "$group"; then
    dfl step skip 'already exists.'
  else
    sudo groupadd "$group"
    dfl step success 'done'
  fi
}

add_user_to_group() {
  local group="$1"
  local user="${2:-}"
  if [ -z "$user" ]; then
    user=$(whoami)
  fi

  dfl step start "Adding '$user' to group '$group'..."

  if user_has_group "$group" "$user"; then
    dfl step skip 'already exists.'
  else
    sudo usermod -a -G "$group" "$user"
    dfl step success 'done'
  fi
}
