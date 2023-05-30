#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

usage() {
  echo "Usage: $0 [winehq branch] [debian codename]"
  exit 1
}


FLAVOR=${1:-staging}
DEBIAN=${2:-$TESTING}

if [ "$( echo -e "$RELEASES" | grep ^$DEBIAN$ )" = "" ] ; then
  echo "\"$DEBIAN\" is not a Debian codename"
  usage
fi

if [ "$( echo -e "$FLAVORS" | grep ^$FLAVOR$ )" = "" ] ; then
  echo "\"$FLAVOR\" is not stable, staging or devel"
  usage
fi


TAG="$( winehq $DEBIAN $FLAVOR)-$FLAVOR-$DEBIAN"
LATEST="$( latest )-staging-$TESTING"

docker build \
  --build-arg WINEHQ=$FLAVOR \
  --build-arg DEBIAN=$DEBIAN \
  -t $REPO:$TAG \
  ./docker

#docker push 0lfi/winehq:$TAG

if [ "$TAG" == "$LATEST" ] ; then
  docker tag  $REPO:$TAG $REPO:latest
#  docker push $REPO:latest
fi
