#!/bin/bash 
[ -f kazhed-cemu.cid ] && rm kazhed-cemu.cid
docker volume create cemu
docker build --no-cache -t kazhed/emulator_cemu --rm -f ./Dockerfiles/Cemu.dockerfile .
