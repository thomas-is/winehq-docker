#!/bin/bash

BASE_DIR=$( realpath $( dirname $0 ))

for DEBIAN in $( cat $BASE_DIR/debian | grep -v \# )
do
  printf "%12s: " $DEBIAN
  WINE=$( docker run --rm -it i386/debian:$DEBIAN-slim \
    bash -c "apt-get update > /dev/null && apt-cache show wine" 2> /dev/null \
    | grep Version \
    | sed 's/^Version: //g' \
    | cut -f1 -d'-' \
    | sed 's/~.*//g' \
    | tr -d '\r' )
  printf "wine-$WINE\n"
done

