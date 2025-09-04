#!/bin/bash

REPO=0lfi/winehq

#trixie
RELEASES=$( cat << EOF
bookworm
bullseye
buster
EOF
)
#stretch
#jessie
#wheezy

BRANCHES=$( cat << EOF
stable
staging
EOF
)

TESTING="$( echo -e "$RELEASES" | head -n 1 )"

validBranch() {
  if [ "$( printf "%s\n" "$BRANCHES" | grep $BRANCH )" = "" ]; then
    echo "winehq \"$BRANCH\" is not a valid branch"
    exit 1
  fi
}

validDebian() {
  if [ "$( printf "%s\n" "$RELEASES" | grep ^$DEBIAN$ )" = "" ]; then
    echo "debian \"$DEBIAN\" is not a valid codename"
    exit 1
  fi
}

# expects a winehq version such as "8.0~rc5~bookworm-1"
# returns debian codename "bookworm"
debianOf() {
  echo "$1" \
    | rev \
    | cut -f1 -d"~" \
    | rev \
    | cut -f1 -d"-"
}

listPackages() {
  BRANCH="${1:-stable}"
  DEBIAN="${2:-$TESTING}"
  validBranch
  validDebian
  PACKAGES=$( curl -s https://dl.winehq.org/wine-builds/debian/dists/$DEBIAN/main/binary-i386/Packages )
  echo "$PACKAGES" \
    | grep -A8 "Package: winehq-$BRANCH" \
    | grep "Version:" \
    | awk '{ print $2 }' \
    | sort -t. -k 1,1nr -k 2,2nr -k 3,3nr -k 4,4nr \
    | uniq \
    | cut -f2 -d":" \
    | tr -d " "
}

latestPackage() {
  listPackages $1 $2 | head -n 1
}

getImageTag() {
  PACKAGE=$1
  if [ "$PACKAGE" = "" ]; then
    echo "package \"$PACKAGE\" is not a valid package"
    exit 1
  fi
  DEBIAN=$( debianOf $PACKAGE )
  validDebian
  VERSION=$( echo $PACKAGE \
    | sed 's/-[0-9]*$//g' \
    | sed "s/~$DEBIAN$//g" \
  )
  tag=$( getWineBranch )-$VERSION-$DEBIAN
  echo $tag
}

getWineBranch() {
  DEBIAN="${DEBIAN:-$TESTING}"
  # returns $FLAVOR-$VERSION-$DEBIAN
  BRANCH=""
  for WINEHQ in $FLAVORS; do
    valid=$( listVersions $WINEHQ $DEBIAN | grep ^$PACKAGE$ )
    if [ "$valid" != "" ]; then
      BRANCH=$WINEHQ
      break;
    fi
  done
  if [ "$BRANCH" = "" ] ; then
    echo "package \"$PACKAGE\" in debian \"$DEBIAN\" not found"
    exit 1
  fi
  echo $BRANCH
}

#latestVersion
#listVersions $1 $2
#getImageTag $1
#getImageTag "8.0~rc5~bookworm-1"
