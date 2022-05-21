#!/bin/bash


for DEBIAN in buster bullseye testing
do
  printf "%12s: " $DEBIAN
  WINE=$( docker run --rm -it i386/debian:$DEBIAN-slim bash -c "apt-get update > /dev/null && apt-cache show wine | grep Version | sed 's/^Version: //g' | cut -f1 -d'-' | sed 's/~.*//g'" 2> /dev/null)
  printf "wine-$WINE\n"
done

