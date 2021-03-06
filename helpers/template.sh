#!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

# Application must be installed either in container or $HOME and store files inside $HOME

APP=MYAPP
APPDIR=$HOME/.local/$APP
EXEC=$APPDIR/App.exe

DECFG="[Desktop Entry]
Name=$App
Comment=Start a container running $APP
Exec=docker start gaming-container-$APP
Terminal=false
Icon=$AppIcon
Type=Application
Categories=CNT;"

COMPATIBILITY_MESSAGE="$APP needs an image built with experimental LLVM [--experimental=llvm]"


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


}

function run() {
  echo "Run application $EXEC"
  $EXEC 
}



[ -f $EXEC ]||setup
run 

