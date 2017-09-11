#!/usr/bin/bash
EXEC=/bin/steam-native


function setup() {
sudo pacman -Syu steam --noconfirm
exit 0
}

function  run() {
$EXEC
}

[ -f $EXEC ] || setup
run
