#!/bin/bash

WINE_DOCKER="6.0.3"
ROOT_DIR="/home/thomas/games/ftl"
RUN_EXE="FTLGame.EXE"

docker run --rm -it \
  --name wine \
  --device /dev/dri \
  --device /dev/input \
  --hostname $( hostname ) \
  --ipc="host" \
  -e USER_ID=$(id -u) \
  -e VIDEO_GID=$(  cat /etc/group | grep video  | cut -f3 -d":" ) \
  -e HOME=/home/wine \
  -e DISPLAY=unix$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/home/wine/.Xauthority:ro \
  -e PULSE_SERVER=unix:/pulse \
  -v /run/user/$(id -u)/pulse/native:/pulse \
  -v $ROOT_DIR/app:/home/wine/app \
  -v $ROOT_DIR/user:/home/wine/user \
  -v $ROOT_DIR/wineprefix:/home/wine/.wine \
  -w /home/wine/app \
  0lfi/wine:$WINE_DOCKER \
  bash -c "su wine -p -c \"wine $RUN_EXE"\"
#  -e WINETRICKS="$WINETRICKS" \
