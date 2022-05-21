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

info setup audio group
run groupmod -g $AUDIO_GID audio
info setup video group
run groupmod -g $VIDEO_GID video
info setup wine user
run usermod wine -u $USER_ID
run usermod -a -G audio  wine
run usermod -a -G video  wine
run chown wine /home/wine

## skip MONO install on init
#su wine -c "WINEDLLOVERRIDES=\"mscoree=\" wineboot"
info boot wine
run su wine -c "wineboot"

SRC="/home/wine/local-settings"
LINK="/home/wine/.wine/drive_c/users/wine/Local\ Settings"
if [ -d "$SRC" ] ; then
  warn "found $SRC, forcing symlink"
  run rm -rf "$LINK"
  run ln -s /home/wine/local-settings "$LINK"
fi

# winetricks section
if [ "$WINETRICKS" != "" ] ; then
  info "winetricks"
  run su wine -c "winetricks $WINETRICKS"
fi

exec "$@"
