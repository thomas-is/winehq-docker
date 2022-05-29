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

info "$(realpath $0)"
run export WINEARCH="win32"
run groupmod -g $VIDEO_GID video
run usermod wine -u $USER_ID
run usermod -a -G video  wine
run chown wine:wine /home/wine
wineRun mkdir -p /home/wine/.wine

LINK="/home/wine/.wine/drive_c/users/wine"
TARGET="/home/wine/user"
if [ -d "$TARGET" ] ; then
  ok "found $TARGET"
  warn "forcing symlink to $LINK"
  wineRun rm -rf $LINK
  wineRun mkdir -p $( dirname $LINK )
  wineRun ln -s "$TARGET" "$LINK"
fi

ok "booting wine"
## skip MONO install on init
#su wine -c "WINEDLLOVERRIDES=\"mscoree=\" wineboot"
wineRun wineboot
wineRun winetricks ${WINETRICKS}

exec "$@"
