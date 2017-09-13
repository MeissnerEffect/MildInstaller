#!/usr/bin/bash

# Cemu is installed in WINEPREFIX=~/drive_c/cemu

. /launcher/settings.sh

export WINEARCH="win64" 
export WINEPREFIX="$HOME/.cemu_prefix"
export WINEDEBUG="-all"

APPDIR=$WINEPREFIX/drive_c/cemu
EXEC=$APPDIR/latest/Cemu.exe
cemu_version="cemu_${INSTALL_CEMU}"
MENUDIR=$HOME/.local/share/applications/cemu

DECFG="[Desktop Entry]
Name=Wine Cemu's settings
Comment=Allow to change Cemu's prefix settings
Exec=winecfg
Terminal=false
Icon=wine-winecfg
Type=Application
Categories=WineCNT;"

DEBRW="[Desktop Entry]
Name=Browse Cemu's C: Drive
Comment=Browse your virtual C: drive
Exec=wine winebrowser c:
Terminal=false
Type=Application
Icon=folder-wine
Categories=WineCNT;"

DERUN="[Desktop Entry]
Name=Cemu
Comment=Launch CEMU inside a container
Exec=docker start gaming-container-cemu
Terminal=false
Icon=wine-winecfg
Type=Application
Categories=WineCNT;"

function setup() {
  WINEARCH=$WINEARCH WINEPREFIX=$WINEPREFIX wineboot -u
  echo curl http://cemu.info/releases/${cemu_version}.zip  
  curl http://cemu.info/releases/${cemu_version}.zip > $HOME/cemu.zip; 
  mkdir -p $APPDIR
  unzip -qq $HOME/cemu.zip -d $APPDIR  
  rm $HOME/cemu.zip
  [ -L $APPDIR/latest ] && unlink $APPDIR/latest
  CE=$(ls -ltr $APPDIR | tail -1 | awk '{ print $NF}')
  ln -s $APPDIR/$CE $APPDIR/latest
  sed -e "s/#version 420/#version 450/" -i $EXEC ;
  chmod +x $EXEC
  mkdir -p $MENUDIR
  echo $DERUN > $MENUDIR/cemu.desktop
  #echo $DEBRW > $MENUDIR/browse-cemu.desktop
  #echo $DECFG > $MENUDIR/configure-cemu.desktop

  exit 0
}

function run {
WINEDEBUG="-all" MESA_GL_VERSION_OVERRIDE=4.5COMPAT MESA_GLSL_VERSION_OVERRIDE=450 MESA_RENDERER_OVERRIDE="Mesa" MESA_VENDOR_OVERRIDE="X.Org" wine64 $EXEC 
}

[ -f $EXEC ]||setup
run 

