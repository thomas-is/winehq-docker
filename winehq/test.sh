#!/bin/bash

docker build --build-arg DEBIAN=bookworm -t winehq ./docker || exit 1

ROOT_DIR="/home/thomas/games/test"
WINETRICKS="isolate_home vd=1920x1080 d3dx9_41 renderer=gl videomemorysize=1024"
WINEDLLOVERRIDES=""
#RUN_EXE="Vampire.exe -game Unofficial_Patch -console"

mkdir -p $ROOT_DIR
. $(dirname $(realpath $0) )/bin/docker-run.sh
