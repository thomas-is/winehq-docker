#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

BRANCH="${1:-stable}"
DEBIAN=${2:-$TESTING}
PACKAGES=$( curl -s https://dl.winehq.org/wine-builds/debian/dists/$DEBIAN/main/binary-i386/Packages )

listVersions() {
  echo "$PACKAGES" \
    | grep -A2 "Package: winehq-$BRANCH" \
    | grep "Version:" \
    | awk '{ print $2 }' \
    | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr \
    | uniq \
    | cut -f2 -d":" \
    | tr -d " " \
    | sed "s/.*$/$BRANCH $DEBIAN &/g"
}

debianOf() {
# expects a version as "8.0~rc5~bookworm-1"
# returns debian codename "bookworm"
  echo "$1" \
    | rev \
    | cut -f1 -d"~" \
    | rev \
    | cut -f1 -d"-"
#    | sed 's/-.*$//g'
}

listVersions $BRANCH
#debianOf 7.0~rc1~bookworm-1
