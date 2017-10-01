#!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

APP=CEMU
APPDIR=$HOME/.local/$APP
export WINEPREFIX="$HOME/.cemu_prefix"
EXEC="$WINEPREFIX/drive_c/cemu/Cemu.exe"



CEMU_HOOK="https://files.sshnuke.net/cemuhook_1100c_0541.zip"
CEMU="http://cemu.info/releases/cemu_1.9.1.zip"

export WINEARCH=win64
export WINEDEBUG="-all"
export MESA_GL_VERSION_OVERRIDE=4.5COMPAT
export MESA_GLSL_VERSION_OVERRIDE=450

DECFG="[Desktop Entry]
Name=$APP
Comment=Start a container running $APP
Exec=docker start gaming-container-$APP
Terminal=false
Icon=$AppIcon
Type=Application
Categories=CNT;"

COMPATIBILITY_MESSAGE="Dolphin requires nothing special"
DEPENDENCIES="qt5 sdl2 cmake libcurl-compat"


function install_dependencies () {
  sudo pacman -S --needed --noconfirm $DEPENDENCIES

}

function supported {
  return 0
 
}

function check_compatibility() {
 [ supported ] || ( echo "This configuration is not compatible with this product"; echo $COMPATIBILITY_MESSAGE; exit -1)
}


function graphical_setup() {
  echo "Installation in progress ..."
  exit 0
}

function text_setup() {
  echo "Installation in progress ..."
  
  exit 0
}

function setup() {
  text_setup

}

function run() {
  echo "Run application $EXEC"
  $EXEC 
}

[ -f $EXEC ]||setup
run 

