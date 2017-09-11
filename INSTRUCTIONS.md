
This is in a preliminary test phase, as such it should not be considered ready :)
Actually I need it to be tested on various distribution  Mint, Ubuntu, Fedora, Suse, etc.

You need docker !




Content:

- 01-build_container.sh  
Create an archlinux container using Docker. Mesa and Wine will be installed automatically.
You can see the various tuning (and you're advised to do so) by running
./01-build_container.sh --help


- 02-run_container.sh
Allow to run native and wine applications using the aforementioned container

- 03-build_cemu_container.sh
Create a container using the previous stages and setup Cemu 1.9.0 inside


- 04-run_cemu.sh
Run the previously created container 

1 Building container
  The first thing to do is to build using 01-build_container.sh, everything after depends on it  

2 Running container 
  By default the container will only incorporate your home directory, if you wish to add more things, 
  edit the variable accordingly in the script 02-run_container.sh or 04-run_cemu.sh

Example:

To add directory /srv/storage/MyApps to the container copy the file 02-run_container.sh and edit it, like this

VISIBLE_DIRECTORIES=( $HOME "/srv/storage/MyApps" )

In any cases it's a docker container, modifications outside of the directory you incorporated are volatile
unless you commit them using "docker commit"

3 (ARCH only) if you're satisfied and wish to update drivers you can run 

  99-start_local_repository_and_update_mesa.sh





To put it simply follow this steps


Inside this directory do :
- Build the container
$ ./01-build-container.sh
- Test it (if your application is in your $HOME)
$ ./02-run_container.sh
- Start your application
$ cd /home/me/application; wine Myapplication.exe








