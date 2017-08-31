#!/bin/bash

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
XAUTH=/tmp/.docker.xauth
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


args="$@"

touch $XAUTH
DISPLAY=:0.0
xauth nlist $DISPLAY | sed -e 's/^..../ffff/' | xauth -f $XAUTH nmerge -

PARAMS=$(setup_Params)

docker run \
	$PARAMS \
  -e XDG_RUNTIME_DIR=$XDG_RUNTIME_DIR \
  -e DISPLAY=$DISPLAY \
	-e XAUTHORITY=$XAUTH \
  -v cemu:/cemu:rw \
	$args --privileged  kazhed/emulator_cemu 

#cid=$(docker ps -lq)
#docker commit $cid kazhed/emulator_cemu
