#!/bin/bash
# Name of the container and of the host
CNAME=kazhed-cemu
CIDFILE=${CNAME}.cid
HNAME=cemu-container
INAME=kazhed/emulator_cemu

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

function setup_Params {
  PARAMS=""
  for directory in ${VISIBLE_DIRECTORIES[*]};
  do
    PARAMS+=" --volume=${directory}:${directory}:rw";
  done

  for device in ${DEVICE_DRIVERS[*]};
  do
    PARAMS+=" --device=${device}:${device}:rw";
  done

  for socket in ${VISIBLE_SOCKETS[*]};
  do
    PARAMS+=" --volume=${socket}:${socket}:rw";
  done

  echo $PARAMS
}


function ImageExists {
  docker images $INAME |grep -q latest
}

function ContainerIsUp {
  docker ps | grep -q $INAME
}

function PrepareSocket {
  if [ ! -f $XAUTH ]; then
    echo "Creating X11 socket"
    touch $XAUTH
    DISPLAY=:0.0
    xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -
  fi
}

function Create {
  echo "Creating/Configuring container"
  PARAMS=$(setup_Params)
  docker create                            \
    $PARAMS                             \
    -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
    -e DISPLAY=$DISPLAY                 \
    -e XAUTHORITY=$XAUTH                \
    -v cemu:/cemu:rw                    \
    --name $CNAME                       \
    -h $HNAME                           \
    $ARGS                               \
    --privileged  $INAME 
}

function Stop {
  CONTAINERNAME=$(docker ps --filter ancestor=$INAME --format {{.ID}})
#  echo "Stopping Container $CONTAINERNAME"
#  docker stop $CONTAINERNAME
#  docker wait $CONTAINERNAME
}

ARGS="$@"

echo -n "Checking if image exists: "
[ $(ImageExists) ]&&(echo "Image doesn't exist, build it first !";exit -1) || echo "OK"
echo -n "Checking if the container is not already running: "
[ $(ContainerIsUp) ]&&echo "OK"||( echo "Container is already running, stopping it"; Stop )
PrepareSocket
docker container list --all|grep -q $CNAME && docker rm $CNAME


Create

