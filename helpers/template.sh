#!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

# Application mush be installed either in container or $HOME and store files inside $HOME

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


function setup() {
  echo "Setting up application $EXEC"
  exit 0
}

function run {
  echo "Run application $EXEC"
  $EXEC 
}



[ -f $EXEC ]||setup
run 

