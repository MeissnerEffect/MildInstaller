FROM kazhed/mesamild
LABEL \ 
  version="0.99a" \
  description="Container that acts as an archlinux repository"
EXPOSE 30200 
USER root
WORKDIR /var/cache/pacman/pkg
RUN \ 
  repo-add /var/cache/pacman/pkg/mesamild.db.tar.gz /var/cache/pacman/pkg/*.pkg.tar.xz   
CMD echo "Repository mesamild is accepting request on http://localhost:30200/" ; python2  -m SimpleHTTPServer 30200
