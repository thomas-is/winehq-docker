#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

for BRANCH in $FLAVORS
do
  echo "$BRANCH"
  for DEBIAN in $RELEASES
  do
    printf "  %s-%s-%s\n" $( winehq $DEBIAN $BRANCH ) $BRANCH $DEBIAN
  done
done

