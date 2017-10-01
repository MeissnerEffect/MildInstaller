helpers/citra.sh                                                                                    0000755 0025543 0024421 00000000000 13164165037 014600  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           helpers/dolphin.sh                                                                                  0000755 0025543 0024421 00000002573 13164137063 015152  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           #!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

APP=DOLPHIN
APPDIR=$HOME/.local/$APP
EXEC="/usr/local/bin/dolphin"

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
  pacman -S --needed --noconfirm $DEPENDENCIES

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
  sudo chown $USER /usr/src
  cd /usr/src/
  git clone --recursive https://github.com/dolphin-emu/dolphin.git
  cd /usr/src/dolphin
  NCPUS=$(cat /proc/cpuinfo  | grep processor | wc -l); \
  echo MAKEFLAGS="-j$NCPUS"
  mkdir build && cd build
  cmake .. -DCMAKE_C_FLAGS="-O3 -march=native" -DCMAKE_CXX_FLAGS="-O3 -march=native" -DCMAKE_BUILD_TYPE=Release
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

                                                                                                                                     helpers/rpcs3.sh                                                                                    0000755 0025543 0024421 00000003022 13164140172 014530  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           #!/usr/bin/bash

BASE_DIR=/launcher
CONF_FILE=$BASE_DIR/settings.sh
. $CONF_FILE

APP=RPCS3
APPDIR=$HOME/.local/$APP
EXEC="/usr/local/bin/rpcs3"

DECFG="[Desktop Entry]
Name=$APP
Comment=Start a container running $APP
Exec=docker start gaming-container-$APP
Terminal=false
Icon=$AppIcon
Type=Application
Categories=CNT;"
COMPATIBILITY_MESSAGE="Rpcs3 needs an image built with experimental LLVM [--experimental=llvm]"

DEPENDENCIES="qt5 sdl2 cmake libcurl-compat"


function install_dependencies () { 
  pacman -S --needed --noconfirm $DEPENDENCIES

}

function supported {
  return 0
 
}


function patch() {
git remote add https://github.com/Zangetsu38/rpcs3.git Zangetsu38
git fetch --all
git merge Zangetsu38/llvm50

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
  sudo chown $USER /usr/src
  cd /usr/src/
  git clone --recursive https://github.com/RPCS3/rpcs3.git
  cd /usr/src/rpcs3
  NCPUS=$(cat /proc/cpuinfo  | grep processor | wc -l); \
  echo MAKEFLAGS="-j$NCPUS"
  cmake . -DCMAKE_C_FLAGS="-O3 -march=native" -DCMAKE_CXX_FLAGS="-O3 -march=native" -DCMAKE_BUILD_TYPE=Release
  make GitVersion
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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              helpers/steam.sh                                                                                    0000755 0025543 0024421 00000000523 13164157200 014612  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           #!/usr/bin/bash

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
                                                                                                                                                                             helpers/steam_wine.sh                                                                               0000755 0025543 0024421 00000000651 13156035330 015636  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           #!/usr/bin/bash

WINEDEBUG="-all"
WINEARCH="win64" 
WINEPREFIX="$HOME/.steam_prefix"
APPDIR="${WINEPREFIX}/drive_c/Program Files (x86)/Steam/" 
EXEC=$APPDIR/Steam.exe

function setup() {
  WINEDEBUG="-all" WINEARCH=$WINEARCH WINEPREFIX=$WINEPREFIX wineboot -u
  WINEDEBUG="-all" WINEARCH=$WINEARCH WINEPREFIX=$WINEPREFIX winetricks steam
  exit 0
}

function run {
WINEDEBUG="-all" wine64 $EXEC 
}

[ -f $EXEC ]||setup
run 

                                                                                       helpers/template.sh                                                                                 0000755 0025543 0024421 00000001640 13164127077 015326  0                                                                                                    ustar   mikael                          domain users                                                                                                                                                                                                           #!/usr/bin/bash

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

COMPATIBILITY_MESSAGE="Rpcs3 needs an image built with experimental LLVM [--experimental=llvm]"


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

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                