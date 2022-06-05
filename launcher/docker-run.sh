#!/bin/bash

if [ ! -d "$ROOT_DIR" ] ; then
  echo "[warn] ROOT_DIR '$ROOT_DIR' is missing!"
  ROOT_DIR="$HOME/wine-docker"
  mkdir -p "$ROOT_DIR/app"
  echo "[info] defaulting to $ROOT_DIR"
fi

CMD="su wine -p -c \"wine $RUN_EXE\""
if [ ! -f "$ROOT_DIR/app/$RUN_EXE" ] ; then
  echo "RUN_EXE '$RUN_EXE' not found, defaulting to bash"
  CMD="su wine -p -c \"bash -l\""
fi

docker run --rm -it \
  --name wine \
  --device /dev/dri \
  --device /dev/input \
  --hostname $( hostname ) \
  --ipc="host" \
  -e USER_ID=$(id -u) \
  -e VIDEO_GID=$(  cat /etc/group | grep video  | cut -f3 -d":" ) \
  -e WINETRICKS="${WINETRICKS:-isolate_home}" \
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
  -e WINEDLLOVERRIDES="$WINEDLLOVERRIDES" \
  0lfi/wine:${WINE_DOCKER:-latest} \
  bash -c "$CMD"
