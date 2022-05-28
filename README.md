# wine-docker

## TL;TR

```bash
#!/bin/bash

ROOT_DIR="/some/place/to/setup/wine"

docker run --rm -it \
  --name wine \
  --device /dev/dri \
  --device /dev/snd \
  --device /dev/input \
  --hostname $( hostname ) \
  --ipc="host" \
  -v $ROOT_DIR:/home/wine \
  -e USER_ID=$(id -u) \
  -e AUDIO_GID=$(  cat /etc/group | grep audio  | cut -f3 -d":" ) \
  -e VIDEO_GID=$(  cat /etc/group | grep video  | cut -f3 -d":" ) \
  -e WINETRICKS="$WINETRICKS" \
  -e HOME=/home/wine \
  -e DISPLAY=unix$DISPLAY \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v $HOME/.Xauthority:/home/wine/.Xauthority:ro \
  -e PULSE_SERVER=unix:/pulse \
  -v /run/user/$(id -u)/pulse/native:/pulse \
  -w /home/wine/app \
  0lfi/wine:6.0.3
```
