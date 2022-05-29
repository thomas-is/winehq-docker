#!/bin/bash

if [ ! -d "$ROOT_DIR" ] ; then
  echo "ROOT_DIR '$ROOT_DIR' is missing!"
  exit 1
fi

mkdir -p "$ROOT_DIR/app"
mkdir -p "$ROOT_DIR/user"
mkdir -p "$ROOT_DIR/wineprefix"
