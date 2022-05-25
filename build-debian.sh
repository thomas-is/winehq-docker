#!/bin/bash

for DEBIAN in buster bullseye testing
do
  echo
  printf "Using $DEBIAN-slim to build "
  WINE=$( docker run --rm -it i386/debian:$DEBIAN-slim bash -c "apt-get update > /dev/null && apt-cache show wine | grep Version | sed 's/^Version: //g' | cut -f1 -d'-' | sed 's/~.*//g'" 2> /dev/null)
  WINE=$( echo $WINE | tr -d '\r' )
  printf "wine-$WINE\n"
  echo
  docker build --build-arg DEBIAN=$DEBIAN -t 0lfi/wine:$WINE-$DEBIAN ./debian
  docker push 0lfi/wine:$WINE-$DEBIAN
done

