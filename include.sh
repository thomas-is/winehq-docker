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
curl -s https://dl.winehq.org/wine-builds/debian/dists/${1:-$TESTING}/main/binary-i386/Packages \
  | grep -A2 "Package: winehq-${2:-stable}" \
  | grep "Version:" \
  | awk '{ print $2 }' \
  | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr \
  | uniq \
  | head -n 1 \
  | cut -f2 -d":" \
  | tr -d " "
}

latest() {
  winehq $TESTING staging
}
