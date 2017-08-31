

cd ./../Packages
docker container export 54ad264bb880 | tar xvf - --wildcards "*.pkg.tar.xz" --strip=4 
cd -
