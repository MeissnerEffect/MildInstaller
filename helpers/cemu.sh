#!/usr/bin/bash

# Cemu is installed in WINEPREFIX=~/drive_c/cemu
WINEDEBUG="-all" 
MESA_GL_VERSION_OVERRIDE=4.5COMPAT 
MESA_GLSL_VERSION_OVERRIDE=450 
MESA_RENDERER_OVERRIDE="Mesa" 
MESA_VENDOR_OVERRIDE="X.Org"

WINEARCH="win64" 
WINEPREFIX="$HOME/.cemu_prefix"

APPDIR=$WINEPREFIX/drive_c/cemu
EXEC=$APPDIR/latest/Cemu.exe
cemu_version="cemu_${cemu}"

function setup() {
  DISPLAY= wineboot -u
  echo curl http://cemu.info/releases/${cemu_version}.zip  
  curl http://cemu.info/releases/${cemu_version}.zip > /tmp/cemu.zip; 
  mkdir -p $APPDIR
  unzip -qq /tmp/cemu.zip -d $APPDIR  
  rm /tmp/cemu.zip
  CE=$(ls -ltr $APPDIR | tail -1 | awk '{ print $NF}')
  ln -s $APPDIR/$CE $APPDIR/latest
  sed -e "s/#version 420/#version 450/" -i $EXEC ;
  chmod +x $EXEC
  exit 0
}

function run {
wine64 $EXEC
}

[ -f $EXEC ]||setup
run 

