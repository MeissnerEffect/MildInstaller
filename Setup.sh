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

# Select which socket will be available inside the container
SHAREDMEMORY="/dev/shm"
DBUS="/var/lib/dbus"
DBUS_SOCKET="/run/dbus/system_bus_socket"
DBUS_SESSION_BUS_ADDRESS="/run/user/${UID}/bus"
PULSE="/run/user/${UID}/pulse"
XSOCK=/tmp/.X11-unix
XAUTH=/tmp/.${CNAME}.xauth
MACHINE_ID="/etc/machine-id"

VISIBLE_SOCKETS=( $PULSE $DBUS_SESSION_BUS_ADDRESS $DBUS_SOCKET $DBUS $SHAREDMEMORY $XSOCK $XAUTH $MACHINE_ID)

# Various parameters 
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
)

declare -A CONTAINER_SETUP=(
["--add-dir=X"]="Add the X directory in the container"
["--use-cpu=X,Y,Z"]="Use only enumerated CPU"
)

# Vivification
function setup_Params {

# Setup bindings (things to be passed to the container)
  BINDINGS=""
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

  echo $BINDINGS
}


function ImageExists {
  docker images $INAME |grep -q latest
}

function ContainerIsUp {
  docker ps | grep -q $INAME
}

function PrepareSocket {

# Setup X11 display
  if [ ! -f $XAUTH ]; then
    echo "Creating X11 socket"
    touch $XAUTH
    DISPLAY=:0.0
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
  fi
}

function Create {

# Create a container
echo "Creating/Configuring container"
  PARAMS=$(setup_Params)
  docker create                            \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DISPLAY=$DISPLAY                 \
    -e XAUTHORITY=$XAUTH                \
    --name $CNAME                       \
    -h $HNAME                           \
    $ARGS                               \
    --privileged  $INAME
}

function Stop {
  CONTAINERNAME=$(docker ps --filter ancestor=$INAME --format {{.ID}})
}


function show_help_item {
  
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

function create_user {
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

function usage () {
  echo "Usage : $(basename $0)"
  echo "Prepare a new container that includes MesaMild"
  (
    echo "> COMPILER OPTIONS";  show_help_item COMPILER_SETUP;echo "@";
    echo "> MESA OPTIONS";      show_help_item MESA_SETUP;echo "@";
    echo "> OS OPTIONS";        show_help_item ANTERGOS_SETUP;echo "@";
    echo "> EMULATORS OPTIONS"; show_help_item IMAGE_SETUP; echo "@";
    echo "> CONTAINER OPTIONS"; show_help_item CONTAINER_SETUP; echo "@"
  ) | column  -t -s '@' 
  exit -1
}

function prepare_cmdline {
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

  # Build 
  for program_arg in ${INPARMS}; do
    case $program_arg in
    --steam)
      STEAM=0
      ;;
    --wine-steam)
      WINE_STEAM=0
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
    --bleeding-edge)
      BE=1
      ;;
    --add-dir=*)
      directory=$(echo program_arg | sed s/=/\ / | awk '{ $1=""; print }')
      VISIBLE_DIRECTORIES+=( "$directory" )
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

  echo $OUTPARMS

}

function prepare_docker_cmdline {
  
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

function prepare_install {
  INSTALL_FILE=preload/install.sh
  TEMPLATE_FILE=template.sh
  cp helpers/cemu.sh preload/cemu.sh
  
  [ -f $INSTALL_FILE ] && rm $INSTALL_FILE
  echo ". /${TEMPLATE_FILE}" >> $INSTALL_FILE
  echo '[ -z $INSTALL_CEMU ] || bash /cemu.sh' >> $INSTALL_FILE
}


## START

#echo -n "Checking if the container is not already running: "
#[ $(ContainerIsUp) ]&&echo "OK"||( echo "Container is already running, stopping it"; Stop )
#docker container list --all|grep -q $CNAME && docker rm $CNAME

[ "$1" == "--help" ]&&usage;
ARGS=$@

NEWARGS="$(prepare_cmdline)"
ARGS=$NEWARGS
CMDLINE="$(prepare_docker_cmdline)"

create_user
prepare_install


echo "About to run  : docker build --pull -t kazhed/mesamild --build-arg "MY_USERNAME=$(whoami)" "$CMDLINE" . "
echo "Press [enter] to continue OR exit with [CTRL] + [C]"
read

[ -f $CIDFILE ]&&rm $CIDFILE

#docker build --pull -t kazhed/mesamild --build-arg "MY_USERNAME=$(whoami)" $CMDLINE . 
PrepareSocket
ARGS=""
Create


