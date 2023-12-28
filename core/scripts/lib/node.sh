#!/usr/bin/env bash

dotf-node-version() {
  local node_version_file="$DOTF/config/node-version"
  local private_node_version_file="$DOTPR/config/node-version"

  for plugin in "$DOTP"/*; do
    if [ -e "$DOTP/$plugin/config/node-version" ]; then
      private_node_version_file="$DOTP/$plugin/config/node-version"
    fi
  done

  if [ -e "$private_node_version_file" ]; then
    cat "$private_node_version_file"
  else
    cat "$node_version_file"
  fi
}
