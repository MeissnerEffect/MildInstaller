#!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

APP=DOLPHIN
APPDIR=$HOME/.local/$APP
EXEC="/usr/local/bin/citra-qt"

DECFG="[Desktop Entry]
Name=$APP
Comment=Start a container running $APP
Exec=docker start gaming-container-$APP
Terminal=false
Icon=$AppIcon
Type=Application
Categories=CNT;"

COMPATIBILITY_MESSAGE="$APP requires nothing special"
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
  install_dependencies
  sudo chown $MY_USERNAME /usr/src
  cd /usr/src/
  git clone --recursive https://github.com/citra-emu/citra.git
  cd /usr/src/citra
  NCPUS=$(cat /proc/cpuinfo  | grep processor | wc -l); \
  echo MAKEFLAGS="-j$NCPUS"
  mkdir build && cd build
  cmake .. -DCMAKE_C_FLAGS="-O3 -march=native" -DCMAKE_CXX_FLAGS="-O3 -march=native" -DCMAKE_BUILD_TYPE=Release -DUSE_SYSTEM_CURL=1
  make $MAKFLAGS 
  sudo make install
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

