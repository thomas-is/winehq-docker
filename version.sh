#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/fullversion.sh

BRANCH="${1:-stable}"
DEBIAN="${2:-$TESTING}"

listVersions $BRANCH $DEBIAN
