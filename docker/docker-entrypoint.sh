#!/bin/bash

RST="\033[0m"
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
  printf "[${BLU}entrypoint$RST] $CMD\n"
#  $CMD
}

info setup audio and video groups
run groupmod -g $VIDEO_GID video
run groupmod -g $AUDIO_GID audio
run usermod -a -G video  wine
run usermod -a -G audio  wine
info setup user id
run usermod wine -u $USER_ID

## skip MONO install on init
#su wine -c "WINEDLLOVERRIDES=\"mscoree=\" wineboot"
info boot wine
run su wine -c "wineboot"

if [ -d "/home/wine/local-settings" ] ; then
  LINK="/home/wine/.wine/drive_c/users/wine/Local Settings"
  info "setup symlink to ~/local-settings"
  rm -rf "$LINK"
  ln -s /home/wine/local-settings "$LINK"
fi

# winetricks section
if [ "$WINETRICKS" != "" ] ; then
  info "winetricks setup"
  run su wine -c "winetricks $WINETRICKS"
fi

exec "$@"
