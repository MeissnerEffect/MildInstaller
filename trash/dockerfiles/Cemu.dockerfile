FROM kazhed/mesamild
ARG cemu_version=1.9.1
ARG dri_prime=0
ENV WINEDEBUG="-all"\ 
    MESA_GL_VERSION_OVERRIDE=4.5COMPAT \
    MESA_GLSL_VERSION_OVERRIDE=450 \
    MESA_RENDERER_OVERRIDE="Mesa" \
    MESA_VENDOR_OVERRIDE="X.Org"\
    cemu_version="cemu_${cemu_version}"\
    DRI_PRIME=$dri_prime \
    WINEPREFIX=/cemu/.wineprefix \
    WINEARCH=win64 
RUN \
  [ -d /cemu ] || sudo mkdir /cemu; \
  sudo chown $UID -R /cemu/; cd /cemu; \ 
  wget -q http://cemu.info/releases/${cemu_version}.zip;  \
  unzip -qq ${cemu_version}.zip; \
  rm ${cemu_version}.zip;  \
  find /cemu -name "Cemu.exe" -exec sed -e "s/#version 420/#version 450/" -i {} \; ; \
  ln -s ${cemu_version} /cemu/latest; \ 
  DISPLAY= wine64 wineboot -u ; DISPLAY= winetricks -q winxp ; \
  DISPLAY= winetricks -q vcrun2015; DISPLAY= winetricks -q win7 ; \
  exit 0
VOLUME "/cemu"
ENTRYPOINT /usr/bin/wine64  /cemu/latest/Cemu.exe
