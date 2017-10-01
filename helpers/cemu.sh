#!/usr/bin/bash

CEMU_VERSION=1.9.1
CEMU_HOOK_VERSION=1100c_0541

CEMU="http://cemu.info/releases/cemu_${CEMU_VERSION}.zip"
CEMU_HOOK="https://files.sshnuke.net/cemuhook_${CEMU_HOOK_VERSION}.zip"

#MESA SETUP
export mesa_glthread=true
export force_glsl_extensions_warn=true
export allow_higher_compat_version=true
export MESA_GL_VERSION_OVERRIDE=4.5COMPAT
export MESA_GLSL_VERSION_OVERRIDE=450 
export MESA_RENDERER_OVERRIDE="Mesa" 
export MESA_VENDOR_OVERRIDE="X.Org"
export WINEDEBUG="-all"
export WINEARCH=win64
export WINEPREFIX="$HOME/.cemu_prefix"
export WINEDLLOVERRIDES="dbghelp=ni,keystone=n" 
APP=CEMU
DIRECTORY="$WINEPREFIX/drive_c/cemu"
EXEC="$DIRECTORY/cemu_latest/Cemu.exe"

function graphical_setup() {
    echo "Running graphical setup for $APP"
    wineboot -u
    winetricks -q vcrun2015 
    winetricks -q corefonts
 }

function run() {
    echo "Run application $APP :  $EXEC"
    wine64 $EXEC 
}

function text_setup() {

    curl $CEMU > /tmp/cemu.zip
    curl $CEMU_HOOK > /tmp/cemu_hook.zip
    mkdir -p $DIRECTORY
    unzip -qq /tmp/cemu.zip -d $DIRECTORY
    rm /tmp/cemu.zip
    cd $DIRECTORY; ln -s cemu_${CEMU_VERSION} cemu_latest
    unzip -qq /tmp/cemu_hook.zip -d $DIRECTORY/cemu_latest
    rm /tmp/cemu_hook.zip
    sed -e "s/#version 420/#version 450/" -i $EXEC ;
    chmod +x $EXEC
    exit 0
}

function setup() {
    text_setup
    graphical_setup
}

[ -f $EXEC ]||setup
    run 

