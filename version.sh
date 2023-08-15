#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

BRANCH="${1:-stable}"
DEBIAN="${2:-$TESTING}"

echo $BRANCH-$DEBIAN
echo
listPackages $BRANCH $DEBIAN
