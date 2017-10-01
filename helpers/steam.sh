#!/usr/bin/bash


EXEC=/bin/steam-native

function reinstall_mesa() {
  PKG=$(find /usr/src/mesamild -name "*pkg.tar.xz" | tr '\n' ' '); \
  yes | LC_ALL=C sudo pacman -U $PKG --force ;  \
}

function setup() {
  sudo pacman -Sy steam --noconfirm
  reinstall_mesa
  exit 0
}

function  run() {
  $EXEC
  exit 0
}

[ -f $EXEC ]||setup
  run
