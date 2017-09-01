FROM antergos/makepkg
# Usage 
# This should be lanched using Setup.sh
ARG MY_USERNAME
ENV MY_USERNAME=${MY_USERNAME}

# Add files from host to container 
COPY AddToRoot/* /

# Setup Account and allow to "sudo" 
RUN \
  bash /create_user.sh; \
  echo "$MY_USERNAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
  mkdir /usr/src/mesamild; \
  chown ${MY_USERNAME}:users /usr/src/mesamild;

# Download pkgbuild and clone repository
# Speedup 
COPY Packages/* /var/cache/pacman/pkg/

# Toolchain variables
## CFLAGS / CXXFLAGS
ARG compiler_flags
## LDFLAGS
ARG linker_flags

# Configuration switches, search for ENV for default values below
## coma separated list of drivers to enable 
ARG gallium_drivers
ARG dri_drivers
ARG vulkan_drivers
ARG platforms

# Version and rollback selection
## repository
ARG mesa_repository
## branch
ARG mesa_branch
## space separated list of commits to rollback
ARG mesa_rollback 
## wine version to build ["", "-staging", "gaming-nine", "staging-nine" ] UNUSED ATM
ARG wine_version

# Setup sources - adding [mesagit]
RUN \
  nupper=$(cat /etc/pacman.conf | grep -Ein '(^\[)' | tr ":" " " | head -2 | tail -1 | awk '{ print ($1-1)}'); \
  nlines=$(cat /etc/pacman.conf | wc -l); \
  cat /etc/pacman.conf | head -$((nupper)) > /tmp/pac_up; \
  echo -e '[mesa-git]\nServer = http://pkgbuild.com/~lcarlier/$repo/$arch\nSigLevel = Never\n' >>  /tmp/pac_up; \
  cat /etc/pacman.conf | tail -$((nlines-nupper))  >>  /tmp/pac_up; \
  mv /tmp/pac_up /etc/pacman.conf; 


# Switch to multilib 
RUN \
  pacman -Syy; \
  pacman -Sq --needed --noconfirm git $(pacman -Ss base-devel | grep base-devel | tr "/" " " | awk '{print $2}' | grep -v gcc | tr '\n' ' '); \
  pacman -Q | grep -q gcc-multilib || (yes | LC_ALL=C sudo pacman -Sq  gcc-multilib); 
  
# Grab packages
RUN \
  pacman -Syu --needed --noconfirm acl adwaita-icon-theme alsa-lib alsa-plugins apr apr-util arch-install-scripts at-spi2-atk \ 
  at-spi2-core atk attr autoconf automake avahi bash binutils bison bzip2 ca-certificates ca-certificates-cacert  \
  ca-certificates-mozilla ca-certificates-utils cabextract cairo cantarell-fonts compositeproto coreutils cracklib cryptsetup  \
  curl damageproto db dbus dconf desktop-file-utils device-mapper devtools dhcpcd diffutils dnssec-anchors dri2proto dri3proto  \
  driconf e2fsprogs elfutils expat expect fakeroot file filesystem findutils fixesproto flex fontconfig fontforge freeglut  \
  freetype2 gawk gc gcc-libs-multilib gcc-multilib gdbm gdk-pixbuf2 gettext giflib git glew glib2 glibc glu gmp gnupg gnutls  \
  gpgme graphite grep groff gst-plugins-base-libs gstreamer gtk-update-icon-cache gtk2 gtk3 guile gzip harfbuzz  \
  hicolor-icon-theme hwids iana-etc icu inetutils inputproto iproute2 iptables iputils iso-codes jasper json-glib  \
  kbd kbproto keyutils kmod krb5 lcms2 ldns less lib32-alsa-lib lib32-alsa-plugins lib32-attr lib32-bzip2 lib32-dbus  \
  lib32-expat lib32-fontconfig lib32-freetype2 lib32-gcc-libs lib32-gettext lib32-giflib lib32-glib2 lib32-glibc lib32-glu  \
  lib32-gnutls lib32-gst-plugins-base-libs lib32-gstreamer lib32-gtk3 lib32-harfbuzz lib32-icu lib32-lcms2 lib32-libcap  \
  lib32-libdrm lib32-libelf lib32-libffi lib32-libgcrypt lib32-libgpg-error lib32-libldap lib32-libnl lib32-libpcap  \
  lib32-libpciaccess lib32-libpng lib32-libpulse lib32-libsm lib32-libtxc_dxtn lib32-libunwind lib32-libusb lib32-libva  \
  lib32-libx11 lib32-libxau lib32-libxcb lib32-libxcomposite lib32-libxcursor lib32-libxdamage lib32-libxdmcp lib32-libxext  \
  lib32-libxfixes lib32-libxft lib32-libxi lib32-libxinerama lib32-libxml2 lib32-libxmu lib32-libxrandr lib32-libxrender  \
  lib32-libxshmfence lib32-libxslt lib32-libxv lib32-libxxf86vm lib32-llvm-libs-svn lib32-llvm-svn lib32-mesa-git lib32-mpg123  \
  lib32-ncurses lib32-ocl-icd lib32-openal lib32-orc lib32-pcre lib32-readline lib32-systemd lib32-util-linux lib32-v4l-utils  \
  lib32-wayland lib32-xz lib32-zlib libarchive libassuan libatomic_ops libcap libcap-ng libclc-git libcroco libcups libdaemon  \
  libdatrie libdrm libedit libelf libepoxy libffi libgcrypt libglade libglvnd libgpg-error libice libidn libjpeg-turbo libksba  \
  libldap libmnl libmpc libnftnl libnghttp2 libnl libomxil-bellagio libpcap libpciaccess libpng libpsl libpulse librsvg  \
  libsasl libseccomp libsecret libsm libssh2 libsystemd libtasn1 libthai libtiff libtirpc libtool libtxc_dxtn libunistring  \
  libunwind libusb libutil-linux libva libx11 libxau libxaw libxcb libxcomposite libxcursor libxdamage libxdmcp libxext  \
  libxfixes libxft libxi libxinerama libxkbcommon libxml2 libxmu libxpm libxrandr libxrender libxshmfence libxslt  \
  libxt libxtst libxv libxxf86vm licenses linux-api-headers llvm-libs-svn llvm-ocaml-svn llvm-svn logrotate lz4 lzo m4 make  \
  mesa-demos mesa-git mpfr mpg123 namcap nano ncurses nettle npth ocaml ocaml-ctypes ocl-icd openal opencl-headers openssh  \
  openssl orc p11-kit package-query pacman pacman-mirrorlist pam pambase pango patch pcre pcre2 perl perl-error pinentry  \
  pixman pkg-config popt psmisc pyalpm pygobject2-devel pygtk python python-pyelftools python2 python2-cairo python2-gobject2  \
  randrproto readline recordproto reflector renderproto rsync samba sed serf shadow shared-mime-info sqlite subversion sudo  \
  sysfsutils systemd systemd-sysvcompat tar tcl texinfo tzdata unzip usbutils util-linux v4l-utils videoproto wayland  \
  wayland-protocols wget which wine wine-mono winetricks xcb-proto xdelta3 xextproto xf86driproto \
  xf86vidmodeproto xineramaproto xkeyboard-config xorg-xdriinfo xorg-xmessage xproto xz yajl yaourt zlib

 # Define repositories options 
ENV mesa_repository=${mesa_repository:-'https://github.com/mikakev1/mesa_mild_compatibility.git'} \
    mesa_branch=${mesa_branch:-master} \
    mesa_rollback=${mesa_rollback:-2b8b9a56efc24cc0f27469bf1532c288cdca2076} 

# Download pkgbuild and clone repository
USER $MY_USERNAME
WORKDIR /usr/src/mesamild
RUN \
  yaourt -G mesa-git ; yaourt -G lib32-mesa-git;\
  git clone $mesa_repository -b $mesa_branch mesa 

# Revert commits 
WORKDIR /usr/src/mesamild/mesa
RUN \
  git config user.email "dontc@re.com"; \
  git config user.name "Lambig Gwinardant"; \
  for a in $mesa_rollback; do git revert $a --no-edit ; done 

# Setup toolchain options
ENV compiler_flags=${compiler_flags:-'"-O2 -march=native"'} \
    linker_flags=${linker_flags:-'"-Wl,-O2 -Wl,--sort-common -Wl,-z,now"'}

# Autoconf feeding
ENV gallium_drivers=${gallium_drivers:-'i915,r300,r600,radeonsi,nouveau,svga,swrast,virgl'} \
    dri_drivers=${dri_drivers:-'i915,i965,r200,radeon,nouveau,swrast'} \
    vulkan_drivers=${vulkan_drivers:-'intel,radeon'} \
    platforms=${platforms:-'x11,drm,wayland'}

USER root
RUN \
  echo CFLAGS=$compiler_flags >> /etc/makepkg.conf; \
  echo CXXFLAGS=$compiler_flags >> /etc/makepkg.conf; \
  echo LDFLAGS=$linker_flags >> /etc/makepkg.conf; \
  NCPUS=$(cat /proc/cpuinfo  | grep processor | wc -l); \
  echo MAKEFLAGS="-j$NCPUS" >> /etc/makepkg.conf;

USER $MY_USERNAME    
# Creating filter for PKGBUILD
RUN \ 
  echo "s/--with-gallium-drivers=\S+/--with-gallium-drivers=$gallium_drivers/;"  > /tmp/filter.pl; \
  echo "s/--with-dri-drivers=\S+/--with-dri-drivers=$dri_drivers/;" >> /tmp/filter.pl; \
  echo "s/--with-vulkan-drivers=\S+/--with-vulkan-drivers=$vulkan_drivers/;" >> /tmp/filter.pl; \
  echo "s/--with-platforms=\S+/--with-platforms=$platforms/;" >> /tmp/filter.pl; \
  echo "s#'mesa::git://anongit.freedesktop.org/mesa/mesa'#'git+file:///usr/src/mesamild/mesa'#;" >> /tmp/filter.pl; 

# Building MESA
#AMD64
WORKDIR /usr/src/mesamild/mesa-git
RUN \
  cat PKGBUILD | perl -pl /tmp/filter.pl > /tmp/PKGBUILD; \
  mv /tmp/PKGBUILD PKGBUILD; \
  makepkg -sf --noconfirm

#I686
WORKDIR /usr/src/mesamild/lib32-mesa-git
RUN \
  cat PKGBUILD | perl -pl /tmp/filter.pl > /tmp/PKGBUILD; \
  mv /tmp/PKGBUILD PKGBUILD; \
  makepkg -sf --noconfirm

WORKDIR /usr/src/mesamild

# Installation  
RUN \
  PKG=$(find . -name "*pkg.tar.xz" | tr '\n' ' '); \
  yes | LC_ALL=C sudo pacman -U $PKG --force ; 

# Move packages to pacman's cache
RUN \
  sudo find /var/cache/pacman/pkg -name "*mesa-git*" -delete ; \
  sudo find /usr/src/mesamild/lib32-mesa-git /usr/src/mesamild/mesa-git  -name "*.pkg.tar.xz" -exec cp {} /var/cache/pacman/pkg \;    

# Clean /usr/src
RUN \
  sudo rm /create_user.sh; \
  sudo rm -rf /usr/src/mesamild

CMD cd ;bash



