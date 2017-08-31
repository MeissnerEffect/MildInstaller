#!/bin/bash 
docker volume create cemu
docker build --no-cache -t kazhed/emulator_cemu --rm -f ./Dockerfiles/Cemu.dockerfile .

