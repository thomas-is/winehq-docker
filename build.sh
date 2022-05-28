#!/bin/bash

BASE_DIR=$( realpath $( dirname $0 ))

REPO="0lfi"

for DEBIAN in $( cat $BASE_DIR/debian | grep -v \# )
do
  echo
  printf "Using $DEBIAN-slim to build "
  WINE=$( docker run --rm -it i386/debian:$DEBIAN-slim \
    bash -c "apt-get update > /dev/null && apt-cache show wine" 2> /dev/null \
    | grep Version \
    | sed 's/^Version: //g' \
    | cut -f1 -d'-' \
    | sed 's/~.*//g' \
    | tr -d '\r' )
  printf "$REPO/wine:$WINE\n"
  echo
  docker build --build-arg DEBIAN=$DEBIAN -t 0lfi/wine:$WINE ./docker
  docker push $REPO/wine:$WINE
done

