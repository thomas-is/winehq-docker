#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

latestPackage $@
#debianOf $1
