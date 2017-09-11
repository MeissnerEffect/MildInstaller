#!/usr/bin/bash

WINEARCH="win64" 
WINEPREFIX="$HOME/.steam_prefix"
APPDIR="${WINEPREFIX}/drive_c/Program Files (x86)/Steam/" 
EXEC=$APPDIR/Steam.exe

function setup() {
  WINEARCH=$WINEARCH WINEPREFIX=$WINEPREFIX wineboot -u
  WINEARCH=$WINEARCH WINEPREFIX=$WINEPREFIX winetricks steam
  exit 0
}

function run {
WINEDEBUG="-all" wine64 $EXEC 
}

[ -f $EXEC ]||setup
run 

