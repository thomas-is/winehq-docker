#!/bin/bash

BASE=$( realpath $( dirname $0 ) )
. $BASE/include.sh

usage() {
  echo "Usage: $0 [branch] [debian] [package]"
  exit 1
}


BRANCH=${1:-staging}
validBranch

DEBIAN=${2:-$TESTING}
validDebian

VERSION=$3

if [ "$VERSION" = "" ]; then
  PACKAGE=$( latestPackage $BRANCH $DEBIAN )
else
  PACKAGE=$( listPackages $BRANCH $DEBIAN | grep $VERSION | head -n 1 )
fi
VERSION=$( echo $PACKAGE | head -n 1 | cut -f1 -d"~")

TAG="$BRANCH-$VERSION-$DEBIAN"
LATEST="staging-$( latestPackage $FLAVOR | cut -f1 -d"~")"

echo  BRANCH=$BRANCH
echo  DEBIAN=$DEBIAN
echo  PACKAGE=$PACKAGE
echo
echo $TAG
echo

docker build \
  --build-arg BRANCH=$BRANCH   \
  --build-arg DEBIAN=$DEBIAN   \
  --build-arg PACKAGE=$PACKAGE \
  -t $REPO:$TAG \
  ./docker || exit 1

docker push 0lfi/winehq:$TAG

if [ "$TAG" == "$LATEST" ] ; then
  docker tag  $REPO:$TAG $REPO:latest
  docker push $REPO:latest
fi
