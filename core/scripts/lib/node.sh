#!/usr/bin/env bash

dotf-node-version() {
  local node_version_file="$DOTF/config/node-version"
  local private_node_version_file=""

  for version_file in "$DOTP"/*/config/node-version; do
    private_node_version_file="$version_file"
  done

  if [ -e "$private_node_version_file" ]; then
    cat "$private_node_version_file"
  else
    cat "$node_version_file"
  fi
}
