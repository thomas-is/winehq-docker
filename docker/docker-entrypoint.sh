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
run mkdir -p /home/wine/.wine/drive_c
run chown -R wine:wine /home/wine/.wine

LINK="/home/wine/.wine/drive_c/users/wine"
ok "booting wine"
## skip MONO install on init
#su wine -c "WINEDLLOVERRIDES=\"mscoree=\" wineboot"
wineRun wineboot
wineRun winetricks ${WINETRICKS}

TARGET="/home/wine/user"
if [ -d "$TARGET" ] ; then
  ok "found $TARGET"
  warn "forcing symlink to $LINK"
  run rm -rf $LINK
  ls -al /home/wine/.wine/drive_c/users
  run mkdir -p $( dirname $LINK )
  ls -al /home/wine/.wine/drive_c/users
  run chown -R wine:wine $( dirname $LINK )
  ls -al /home/wine/.wine/drive_c/users
  wineRun ln -s "$TARGET" "$LINK"
  ls -al /home/wine/.wine/drive_c/users
fi

exec "$@"
