#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

for DEBIAN in $RELEASES
do
  printf "%-12s %s\n" $DEBIAN $( winehq $DEBIAN )
done

