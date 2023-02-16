#!/bin/bash

VERSION=$( cat << EOF
bookworm
bullseye
buster
stretch
jessie
wheezy
EOF
)

for DEBIAN in $VERSION
do
  WINEHQ=$( curl -s https://dl.winehq.org/wine-builds/debian/dists/$DEBIAN/main/binary-i386/Packages \
    | grep Version \
    | sort \
    | uniq \
    | tail -n 1 \
    | cut -f2 -d":" \
    | cut -f1 -d"~" \
    | tr -d " " )
  echo "winehq:$WINEHQ-$DEBIAN"
done
