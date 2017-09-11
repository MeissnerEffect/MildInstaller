#!/usr/bin/bash
CREPOSITORY_NAME="localrepository"
IREPOSITORY_NAME="mesamild/repository"

docker ps | grep -q $CREPOSITORY_NAME && docker stop $CREPOSITORY_NAME 


docker build --force-rm --no-cache -t $IREPOSITORY_NAME  -f Dockerfiles/CreateRepo.dockerfile .
docker run -d -p 30200:30200 --rm --name $CREPOSITORY_NAME $IREPOSITORY_NAME
# 10 second should suffice
sleep 10
sudo pacman --config Config/pacman.conf -Syyud mesagit mesa-git lib32-mesa-git
docker stop $CREPOSITORY_NAME
sleep 10
docker rmi -f $IREPOSITORY_NAME
