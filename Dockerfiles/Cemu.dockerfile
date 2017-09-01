FROM kazhed/mesamild
ARG cemu_version=1.9.1
ARG dri_prime=0
ENV WINEDEBUG="-all"\ 
    MESA_GL_VERSION_OVERRIDE=4.5COMPAT \
    MESA_GLSL_VERSION_OVERRIDE=450 \
    MESA_RENDERER_OVERRIDE="Mesa" \
    MESA_VENDOR_OVERRIDE="X.Org"\
    cemu_version="cemu_${cemu_version}"\
    DRI_PRIME=$dri_prime

RUN \
  [ -d /cemu ] || sudo mkdir /cemu; \
  sudo chown $UID -R /cemu/; cd /cemu; \ 
  wget -q http://cemu.info/releases/${cemu_version}.zip;  \
  unzip ${cemu_version}.zip; \
  rm ${cemu_version}.zip;  \
  find /cemu -name "Cemu.exe" -exec sed -e "s/#version 420/#version 450/" -i {} \; ; \
  ln -s ${cemu_version} /cemu/latest
VOLUME "/cemu"
ENTRYPOINT /usr/bin/wine64  /cemu/latest/Cemu.exe
