#!/usr/bin/env bash

set -euo pipefail

APPS_ROOT=$HOME/.apps
INSTALL_ROOT=$APPS_ROOT/build
BIN_DIR=$APPS_ROOT/bin

function prepare_build() {
  NAME=$1
  DEFAULT_VERSION=$2
  VERSION=${3:-$DEFAULT_VERSION}
  BUILD_DIR=$TMP/build/$NAME
  INSTALL_DIR=$INSTALL_ROOT/$NAME/$VERSION

  dotf-header h2 "Building $NAME $VERSION..."

  mkdir -p "$INSTALL_DIR"

  if [ "${CLEAN:-}" != "no" ]; then
    rm -rf "$BUILD_DIR"
  fi

  mkdir -p "$BUILD_DIR"
  cd "$TMP/build/$NAME"
}

function install_symlinks() {
  local path_to_binary=$1
  if [ $# -ge 2 ]; then
    target_name="$2"
  else
    target_name="$(basename "$path_to_binary")"
  fi

  mkdir -p "$BIN_DIR"
  dotf-symlink "$INSTALL_DIR/$path_to_binary" "$BIN_DIR/$target_name-$VERSION"

  if [ "${PRIMARY:-}" == 'yes' ]; then
    dotf-symlink "$INSTALL_DIR/$path_to_binary" "$BIN_DIR/$target_name"
  fi
}

function install_desktop_entry() {
  path_to_binary=$1
  title=$2
  target_name="$(basename "$path_to_binary")"

  add-desktop-entry "$target_name-$VERSION" "$title $VERSION" "$BIN_DIR/$target_name-$VERSION"

  if [ "${PRIMARY:-}" == 'yes' ]; then
    add-desktop-entry "$target_name" "$title" "$BIN_DIR/$target_name"
  fi
}

function validate-sha256() {
  local filename=$1
  local sha256sum=$2

  if [ "$(sha256sum "$filename" | awk '{print $1}')" == "$sha256sum" ]; then
    dotf-success "SHA256 of $filename is valid"
  else
    dotf-error "SHA256 of $filename doesn't match"
    exit 1
  fi
}
