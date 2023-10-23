#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

BRANCH="${1:-stable}"
DEBIAN="${2:-$TESTING}"

listPackages $BRANCH $DEBIAN | sed "s/.*/$BRANCH $DEBIAN &/"
