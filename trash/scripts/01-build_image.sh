#!/bin/bash

if (( ! $EUID )); then 
  echo "This script cannot be run as root or with sudo"
  echo "Maybe you need to add yourself in docker group?"
  exit -1
else

if [ "x$1" == "x--help" ]; then 
echo "\

Build a docker image that includes cemu and mesamild


USAGE

$0 --enable-lto --enable-native --opt-level=3 --version=1.9.1 --gpu=radeon,intel

*You need to escape quotes where you need them, like in compiler_flags and linker_flags*

Setting          Default Value 
--enable-native                   Activate compiler autodetection of host and optimise accordingly
--enable-lto                      Activate linktime optimisation (needs lot of RAM)
--gpu=r600,i965,radeon,nouveau 
 compiler_flags   \"-O2 -march=native -pipe\"
 linker_flags     \"-Wl,-O2 -Wl,--sort-common -Wl,-z,now\"
 gallium_drivers  i915,r300,r600,radeonsi,nouveau,svga,swrast,virgl
 dri_drivers      i915,i965,r200,radeon,nouveau,swrast
 vulkan_drivers   intel,radeon
 platforms        x11,drm,wayland
 mesa_repository  https://github.com/mikakev1/mesa_mild_compatibility.git
 mesa_branch      master
 mesa_rollback    2b8b9a56efc24cc0f27469bf1532c288cdca2076
 wine_version     unused

TIPS 

I) GPU DRIVERS SELECTION 

  a) Settings for AMD Radeon GCN w/o Intel integrated graphic
    gallium_drivers   radeonsi,swrast
    dri_drivers       ''
    vulkan_drivers    radeon

  b) Settings for intel integrated graphic
    gallium_drivers   swrast
    dri_drivers       i965
    vulkan_drivers    intel

  c) Settings for AMD Radeon GCN w/ Intel intergrated graphic
    gallium_drivers   radeonsi,swrast
    dri_drivers       i965
    vulkan_drivers    intel,radeon

"
exit 1
fi

CIMAGE="kazhed/emulator_cemu"



[ -f kazhed-cemu.cid ] && rm kazhed-cemu.cid
docker volume create cemu


cd AddToRoot
../Helpers/001-create_user_pkgbuilder.sh
cd ..

docker build --pull -t kazhed/mesamild --build-arg "MY_USERNAME=$(whoami)" "$@" -f Dockerfiles/Build.dockerfile . 
docker build --no-cache -t kazhed/emulator_cemu --rm -f ./Dockerfiles/Cemu.dockerfile .
fi