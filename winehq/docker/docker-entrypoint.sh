#!/bin/bash

RST="\033[0m"
BLD="\033[1m"
GRY="\033[2m"
RED="\033[1;31m"
GRN="\033[1;32m"
ORG="\033[1;33m"
BLU="\033[1;34m"

info() {
  ARG="$@"
  printf "[${BLU}entrypoint$RST] ${BLU}$ARG$RST\n"
}
ok() {
  ARG="$@"
  printf "[${BLU}entrypoint$RST] ${GRN}$ARG$RST\n"
}
warn() {
  ARG="$@"
  printf "[${BLU}entrypoint$RST] ${ORG}$ARG$RST\n"
}
run() {
  CMD="$@"
  printf "[${BLU}entrypoint$RST] $GRY$CMD$RST\n"
  eval $CMD
}
wineRun() {
  ARG="$@"
  CMD="su wine -c \"$ARG\""
  printf "[${BLU}entrypoint$RST] $GRY$CMD$RST\n"
  eval $CMD
}

ok "$( wine --version )"
run export WINEARCH="win32"
run groupmod -g $VIDEO_GID video
run groupmod -g $INPUT_GID input
run usermod wine -u $USER_ID
run usermod -a -G $VIDEO_GID wine
run usermod -a -G $INPUT_GID wine
run chown wine:wine /home/wine
run mkdir -p /home/wine/.wine/drive_c
run chown -R wine:wine /home/wine/.wine

LINK="/home/wine/.wine/drive_c/users/wine"
ok "booting wine"
## skip MONO install on init
#su wine -c "WINEDLLOVERRIDES=\"mscoree=\" wineboot"
wineRun wineboot
wineRun winetricks isolate_home ${WINETRICKS}

TARGET="/home/wine/user"
if [ -d "$TARGET" ] ; then
  ok "found $TARGET"
  warn "forcing symlink $LINK > $TARGET"
  run rm -rf $LINK
  run mkdir -p $( dirname $LINK )
  run chown -R wine:wine $( dirname $LINK )
  wineRun ln -s "$TARGET" "$LINK"
fi

if [ "$SET_LAA" != "" ] ; then
  warn "patch $SET_LAA"
  wineRun /usr/local/bin/pe-set-laa /home/wine/app/$SET_LAA
fi

exec "$@"