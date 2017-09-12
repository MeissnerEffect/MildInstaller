#/usr/bin/bash

# Name of the container and of the host
CNAME=gaming-container
CIDFILE=${CNAME}.cid
HNAME=$CNAME
INAME=kazhed/gaming-container
MESA_STABLE=17.2

# Which directories have to be available inside container
VISIBLE_DIRECTORIES=( $HOME )

# Select which device drivers will be used in the container
JOYSTICK="/dev/input/js0"
VIDEOCARD="/dev/dri/card0"
DEVICE_DRIVERS=( $VIDEOCARD $JOYSTICK )

# Select which socket to replicate inside the container
SHAREDMEMORY="/dev/shm"
DBUS="/var/lib/dbus"
DBUS_SOCKET="/run/dbus/system_bus_socket"
DBUS_SESSION_BUS_ADDRESS="/run/user/${UID}/bus"
PULSE="/run/user/${UID}/pulse"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.${CNAME}.xauth
MACHINE_ID="/etc/machine-id"

VISIBLE_SOCKETS=( $PULSE $DBUS_SESSION_BUS_ADDRESS $DBUS_SOCKET $DBUS $SHAREDMEMORY $XSOCK $XAUTH $MACHINE_ID)
declare -a APP_NAMES
APP_BASEDIR=/
# Comment faisait on avant les dictionnaires en bash? En perl, pardi!
# AFAIRE : Mettre les constantes en LS

# Couleur
  noi=$(tput setaf 0) 
  rou=$(tput setaf 1) 
  ver=$(tput setaf 2) 
  mar=$(tput setaf 3)
  ble=$(tput setaf 4)
  vio=$(tput setaf 5)
  cya=$(tput setaf 6)
  bla=$(tput setaf 7)
  sms=$(tput smso)
  rms=$(tput rmso)
  rei=$(tput sgr0)


declare -A INSTALLER_SETUP=(
    ["--help"]="This help"
    ["--trim"]="Trim images"
    ["--update"]="Destroy previous image and restart build process"
    ["--prune"]="Remove every containers and images from this application"
    ["--dump-dl"]="Dump all downloads for reuse"
)

declare -A COMPILER_SETUP=(
    ["--optimise"]="Use safe compiler optimisation"
    ["--optimise-harder"]="Use unsafe compiler optimisation"
    ["--use-lto"]="Use link time optimisation (largely increase building time)"
    ["--clang"]="Build using CLANG"
)

declare -A MESA_SETUP=(
    ["--vulkan"]="Enable vulkan (intel or radeon)"
    ["--radeon"]="Enable radeon support"
    ["--radeon-legacy"]="Enable legacy radeon support (PRE GCN)"
    ["--nouveau"]="Enable nouveau support"
    ["--intel"]="Enable intel support"
    ["--intel-legacy"]="Enable legacy intel support"
)

declare -A ANTERGOS_SETUP=(
    ["--bleeding-edge"]="Use bleeding edge version of packages, (for VEGA)"
    ["--mesa-stable"]="Use stable version of mesa"
    ["--wine-staging"]="Install wine staging instead of wine"
    ["--wine-staging-nine"]="Install wine-staging-nine instead of wine"
    ["--kerberizer-llvm"]="Use LLVM from Kerberizer's repository (for RPCS3)"
)

declare -A IMAGE_SETUP=(
    ["--cemu=X.Y.Z"]="Download the specified version of CEMU @ (http://cemu.info)"
    ["--rpcs3"]="Build RPCS3 from git                        @ (https://rpcs3.net)"
    ["--dolphin"]="Build Dolphin from git                    @ (https://dolphin-emu.org/)"
    ["--citra"]="Build Citra from git                        @ (https://citra-emu.org)"
    ["--steam"]="Install steam                               @ (https://store.steampowered.com/)"
    ["--wine-steam"]="Install steam (wine)                   @ (https://store.steampowered.com/)"
    ["--decaf"]="Build decaf from git                        @ (https://github.com/decaf-emu/decaf-emu/)"
)

declare -A CONTAINER_SETUP=(
    ["--add-dir=X"]="Add the X directory in the container"
    ["--add-device=X"]="Add the char device X in the container"
    ["--use-cpu=X,Y,Z"]="Use only enumerated CPU"
    ["--max-ram=X"]="Hard memory limit"
    ["--max-swap=X,Y"]="Use max swap and define swapiness"
)

# Display 
function socket_setup {
# Setup X11 display

    echo "Creating X11 socket"
    touch $XAUTH
    DISPLAY=:0.0
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
}

function account_generate {
  OUTFILE=preload/create_user.sh
  CUSERNAME=$(id -un)
  CUID=$(id -u)
  CPGID=$(id -g)
  CPGIDNAME=$(cat /etc/group | grep "${CPGID}:")
  cat /etc/group |grep $CUSERNAME|tr ':' ' '|awk '{printf("groupadd -og %d g%d\n",$3,$3)}' > $OUTFILE
  CUSERGROUP=$(cat /etc/group | grep $CUSERNAME  | tr ":" " " | awk '{ print $3}' | tr '\n' ',' | sed s/.$//)
  echo "mkdir -p $(dirname $HOME)" >> $OUTFILE 
  echo "useradd -o -b / -d $HOME -m -G ${CUSERGROUP} -U -u $CUID $CUSERNAME" >> $OUTFILE
}


function usage_generatetext {
  keys=""

  local -n ITEM=$1
  for key in "${!ITEM[@]}"; do
    keys+="$key "
  done

  KEYS=$(echo $keys|tr ' ' '\n'|sort -b)

  for KEY in $KEYS; do
    VAL=${ITEM[$KEY]}
    echo " >   $KEY" "@" $VAL  
  done
  
}

function usage_show () {
  echo "Usage : $(basename $0)"

  echo "Prepare a new container that includes MesaMild"
  (
    echo "> INSTALLER OPTIONS"; usage_generatetext INSTALLER_SETUP;echo "@";
    echo "> COMPILER OPTIONS";  usage_generatetext COMPILER_SETUP;echo "@";
    echo "> MESA OPTIONS";      usage_generatetext MESA_SETUP;echo "@";
    echo "> OS OPTIONS";        usage_generatetext ANTERGOS_SETUP;echo "@";
    echo "> EMULATORS OPTIONS"; usage_generatetext IMAGE_SETUP; echo "@";
    echo "> CONTAINER OPTIONS"; usage_generatetext CONTAINER_SETUP; echo "@"
  )  | column  -t -s '@'|cat|
  sed -e "s/>\ INS/$rou\ INS/g" |
  sed -e "s/>\ COM/$ble\ COM/g" |
  sed -e "s/>\ M/$ver\ M/g"     |
  sed -e "s/>\ OS/$mar\ OS/g"   |
  sed -e "s/>\ EM/$vio\ EM/g"   |
  sed -e "s/>\ CON/$cya\ CON/g" |
  sed -e "s/\-\-\([-a-zA-Z0-9.,=]*\)/$sms\-\-\1${rms}/g" |sed -e "s/>/\ /g"
  echo "$rei"

  exit -1
}

## CONTAINER
function container_create {
  echo "Creating container"
  PARAMETERS=$(container_setupparams)
  echo "docker create $PARAMETERS"
  docker create --entrypoint /usr/bin/bash $PARAMETERS 
}

function container_createapp {
  APP=$1
  echo "Creating container for application $APP"
  PARAMETERS=$(container_setupparams $APP)
  echo "docker create $PARAMETERS"
  docker create -a STDIN --entrypoint /usr/bin/bash $PARAMETERS 
  # ${APP_BASEDIR}${APP}.sh
}

function container_run {

  echo "Performing install in container"
  PARAMETERS=$(container_setupparams)
  echo "docker run $PARAMETERS"
  docker run --entrypoint /usr/bin/bash $PARAMETERS /install.sh
    
}

function container_commit {
    docker commit $CNAME $INAME
}

function container_exists {
    docker container ls --all |grep -q $CNAME

}

function container_stop {
    docker stop $CNAME
}

function container_destroy {
    container_isrunning && container_stop && container_wait 
    docker rm $CNAME

}

function container_isrunning {
    docker ps | grep -q $INAME
}

function container_wait {
    docker wait $CNAME
}

function container_start {
    docker start $CNAME
}

function container_exec {
    CMD=$1
    docker exec $CNAME $CMD
}

function container_setup {
    echo "Creating containers"
    OLD_CNAME=$CNAME
    echo ${APP_NAMES[*]}
    #for app in ${APP_NAMES[*]}; do
    for app in "cemu"; do
      CNAME="${CNAME}${app}"
      container_exists && container_destroy; 
      CNAME=$OLD_CNAME
      container_createapp $app;
    done
}

function container_setup_in {

    container_exists && container_destroy; 
    container_run;
    container_wait;
    container_commit;
    container_destroy;
    for app in ${APP_NAMES[*]}; do
      container_createapp $app;
    done
}

function container_setupparams {

# Setup bindings (things to be passed to the container)
  NAME_SUFFIX=$1
  BINDINGS=" -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR  -e DISPLAY=$DISPLAY -e XAUTHORITY=$XAUTH"
  BINDINGS+=" --name ${CNAME}-${NAME_SUFFIX} -h $HNAME"   
  for directory in ${VISIBLE_DIRECTORIES[*]};
  do
    BINDINGS+=" --volume=${directory}:${directory}:rw";
  done

  for device in ${DEVICE_DRIVERS[*]};
  do
    BINDINGS+=" --device=${device}:${device}:rw";
  done

  for socket in ${VISIBLE_SOCKETS[*]};
  do
    BINDINGS+=" --volume=${socket}:${socket}:rw";
  done
  
  BINDINGS+=" --privileged -it $INAME"

  echo "$BINDINGS"
}


function image_exists {
    docker image ls -a ${INAME}:latest  |grep -q latest
}


function image_fastsetupprepare {
    
    container_exists && (
        echo "Extracting files";
        docker cp  ${CNAME}:/var/cache/pacman/pkg overrides/var/cache/pacman;
        echo "Using extracted files";
        rsync -a overrides/ preload;
    )
}


function cmdline_parse {
# Reformule les options avant de lancer l'analyse des parametres a envoyer au daemon.

OUTSCRIPT="preload/template.sh"
  OUTPARMS=""
  INPARMS="${ARGS}"

  OP_FLAGS=""
  WINE_FLAVOR="wine"
  
  STEAM=""
  WINE_STEAM=""
  RPCS3=""
  CEMU=""
  DOLPHIN=""
  CITRA=""
  CEMU=""

  CC=""
  CXX=""
  VULKAN_DRIVERS=""
  EN_VULKAN=""
  DRI_DRIVERS=""
  GALLIUM_DRIVERS=" swrast virgl "
  KERB=""
  MESA_BRANCH=master
  BE=""
  LDFLAGS="-Wl,--sort-common -Wl,-z,now"
  EN_GALLIUM=""
  EN_DRI=1
  FP=""

  
  for program_arg in ${INPARMS}; do
    case $program_arg in
    --steam)
      STEAM=0
      APP_NAMES+=( "steam.sh" )
      ;;
    --wine-steam)
      WINE_STEAM=0
      ;;
    --cemu*)
      CEMU=$(echo $program_arg | awk -F= '{ print $2 }')
      APP_NAMES+=( "cemu.sh" )
      ;;
    --dolphin)
      DOLPHIN=0
      ;;
    --citra)
      CITRA=0
      ;;
    --optimise)
      OP_FLAGS+='-march=native -O2 -pipe '  
      LDFLAGS="-Wl,-O2 $LDFLAGS"
      ;;
    --optimise-harder)
      OP_FLAGS+='-march=native -O3 -pipe '  
      LDFLAGS="-Wl,-O3 $LDFLAGS"
      EN_DRI=""
      ;;
    --use-lto)
      OP_FLAGS+=' -flto '
      LDFLAGS="$LDFLAGS -Wl,-flto"
      EN_DRI="" 
      ;;
    --wine-staging)
      WINE_FLAVOR="wine-staging"
      ;;
    --wine-staging-nine)
      WINE_FLAVOR="wine-staging-nine"
      ;;
    --clang)
      CXX=clang++; CC=clang
      ;;
    --kerberizer-llvm)
      KERB=1
      ;;
    --rpcs3)
      KERB=1
      OUTPARMS+="--rpcs3 "
      ;;
    --mesa-stable)
      MESA_BRANCH=$MESA_STABLE
      ;;
    --fast-setup)
      FP=""  
      ;;
    --bleeding-edge)
      BE=1
      ;;
    --add-dir=*)
      directory=$(echo $program_arg | sed s/=/\ / | awk '{ $1=""; print }')
      VISIBLE_DIRECTORIES+=( "$directory" )
      ;;
    --add-device=*)
      device=$(echo $program_arg | sed s/=/\ / | awk '{ $1=""; print }')
      DEVICE_DRIVERS+=( "$device" )
      ;;
    *) OUTPARMS+="$program_arg "
    ;;
    esac
  done
 INPARMS=$OUTPARMS
 OUTPARMS=""
 
 # Mesa
 for program_arg in ${INPARMS}; do
  case $program_arg in
    --radeon) 
      GALLIUM_DRIVERS+=" radeonsi "
      VULKAN_DRIVERS+=" radeon "
      EN_GALLIUM=1
      ;;
    --radeon-legacy)
      GALLIUM_DRIVERS+=" r300 r600 "
      EN_GALLIUM=1
      ;;
    --intel)
      DRI_DRIVERS+=" i965 "
      VULKAN_DRIVERS+=" intel "
      EN_DRI=1
      ;;
    --intel-legacy)
      DRI_DRIVERS+=" i915 "
      EN_DRI=1
      ;;
    --nouveau)
      GALLIUM_DRIVERS=" nouveau "
      EN_GALLIUM=1
      ;;
    --vulkan)
      EN_VULKAN=1
      ;;
      
    *)
      OUTPARMS+="$program_arg "
      ;;
  esac
  done
  TEMPLATE_FILE=preload/template.sh
  [ -f $TEMPLATE_FILE ] && rm $TEMPLATE_FILE

  echo "" > $TEMPLATE_FILE
  [ -z $EN_DRI ] && DRI_DRIVERS="''"  #LTO handling
  [ -z $DRI_DRIVERS ]|| OUTPARMS+=" $(echo "--dri_drivers=$DRI_DRIVERS"| tr ' ' ',' | sed s/=,/=/|sed s/,$// |sed s/,,/,/)"
  [ -z $EN_GALLIUM ]|| OUTPARMS+=" $(echo "--gallium_drivers=$GALLIUM_DRIVERS" | tr ' ' ',' | sed s/=,/=/|sed s/,$// |sed s/,,/,/g )"
  [ -z $EN_VULKAN ]|| [ -z $VULKAN_DRIVERS ]||OUTPARMS+=" $(echo "--vulkan_drivers=$VULKAN_DRIVERS"| tr ' ' ',' | sed s/=,/=/|sed s/,$// |sed s/,,/,/)"
  CFLAGS=$(echo "$OP_FLAGS" | sed s/\ \ /\ /) 
  echo CFLAGS=\"$CFLAGS\" >> $TEMPLATE_FILE
  echo CXXFLAGS=\"$CFLAGS\" >> $TEMPLATE_FILE
  echo LDFLAGS=\"$LDFLAGS\" >> $TEMPLATE_FILE
  [ -z $CC ] ||  echo CC=/usr/bin/$CC >> $TEMPLATE_FILE
  [ -z $CXX ] || echo CXX=/usr/bin/$CXX >> $TEMPLATE_FILE
  echo WINE_FLAVOR=$WINE_FLAVOR >> $TEMPLATE_FILE
  [ -z $STEAM ] || echo "INSTALL_STEAM=1" >> $TEMPLATE_FILE
  [ -z $WINE_STEAM ] || echo "INSTALL_WINE_STEAM=1" >> $TEMPLATE_FILE
  [ -z $CITRA ] || echo "INSTALL_CITRA=1" >> $TEMPLATE_FILE
  [ -z $RPCS3 ] || echo "INSTALL_RPCS3=1" >> $TEMPLATE_FILE
  [ -z $DOLPHIN ] || echo "INSTALL_DOLPHIN=1" >> $TEMPLATE_FILE
  [ -z $CEMU ] || echo "INSTALL_CEMU=$CEMU" >> $TEMPLATE_FILE

  echo $OUTPARMS

}

function image_gencmdline {
  
  IMAGE_SWITCHES=""
  
  declare -a VALID_ARGS=$(
  for arg in ${ARGS}; do
    echo "$arg"| grep '\-\-' | sed s/\-\-//g
  done | tr '\n' ' '
  )
  for docker_arg in $VALID_ARGS; do
   SWITCH=$(echo ${docker_arg}|grep -q '=' && echo "$docker_arg" || echo "${docker_arg}=1")
   IMAGE_SWITCHES+="--build-arg $SWITCH "
  done
  echo $IMAGE_SWITCHES
}

function installscript_generate {
  INSTALL_FILE=preload/install.sh
  TEMPLATE_FILE=template.sh
  cp helpers/cemu.sh preload/cemu.sh
  
  [ -f $INSTALL_FILE ] && rm $INSTALL_FILE
  echo ". /${TEMPLATE_FILE}" >> $INSTALL_FILE
  echo '[ -z $INSTALL_CEMU ] || bash /cemu.sh' >> $INSTALL_FILE
  echo '[ -z $INSTALL_STEAM ] || bash /steam.sh' >> $INSTALL_FILE
  echo '[ -z $INSTALL_STEAM_WINE ] || bash /steam-wine.sh' >> $INSTALL_FILE
  echo '[ -z $INSTALL_DOLPHIN ] || bash /dolphin.sh' >> $INSTALL_FILE
  echo '[ -z $INSTALL_CITRA ] || bash /citra.sh' >> $INSTALL_FILE
  echo '[ -z $INSTALL_RPCS3 ] || bash /rpcs3.sh' >> $INSTALL_FILE
}


## Demarrage
[ "$1" == "--help" ]&&usage_show;
[ "$1" == "--fast-setup" ]&&image_fastsetupprepare;


# Interception des parametres
ARGS=$@
NEWARGS="$(cmdline_parse)"
ARGS=$NEWARGS

# Vivification du parametrage
CMDLINE="$(image_gencmdline)"
ARGS=""


# Averti avant de tout casser 
image_exists &&     
    ( 
        echo "Image exists, skipping (use 'docker rmi $INAME' to rebuild ) " ) ||  
    ( 
        echo "About to create an image using : --build-arg MY_USERNAME=$(whoami) $CMDLINE" ;
        echo "Press [enter] to continue OR exit with [CTRL] + [C]";
        read;
        
        # Mise a disposition des scripts
        account_generate
        installscript_generate
        docker build --pull -t $INAME --build-arg "MY_USERNAME=$(whoami)" $CMDLINE . 
    )   


# Prepare le display 
socket_setup

# Monte les peripheriques et joue le reste de l'installation, car elle necessite un display (merci wine...)
container_setup
