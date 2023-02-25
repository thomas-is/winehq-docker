#!/bin/bash

REPO=0lfi/winehq

RELEASES=$( cat << EOF
bookworm
bullseye
buster
stretch
jessie
wheezy
EOF
)

FLAVORS=$( cat << EOF
stable
staging
devel
EOF
)

TESTING="$( echo -e "$RELEASES" | head -n 1 )"

winehq() {
curl -s https://dl.winehq.org/wine-builds/debian/dists/$1/main/binary-i386/Packages \
  | grep Version \
  | sort \
  | uniq \
  | tail -n 1 \
  | cut -f2 -d":" \
  | cut -f1 -d"~" \
  | tr -d " "
}

latest() {
  winehq $TESTING
}

