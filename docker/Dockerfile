ARG DEBIAN
FROM debian:$DEBIAN-slim AS builder

WORKDIR /src
ADD https://raw.githubusercontent.com/randomstuff/pe-set-laa/master/pe-set-laa.c /src/pe-set-laa.c
RUN apt-get update \
  && apt-get install -y gcc \
  && gcc pe-set-laa.c -o pe-set-laa


ARG DEBIAN
FROM debian:$DEBIAN-slim AS base

RUN dpkg --add-architecture i386 \
  && apt-get update \
  && apt-get install -y \
    ca-certificates \
    cabextract \
    gnupg \
    joystick \
    mesa-vulkan-drivers \
    mesa-vulkan-drivers:i386 \
    libvulkan1 \
    libvulkan1:i386 \
    p7zip-full \
    pulseaudio \
    sudo \
    unzip \
    vulkan-tools \
    winbind \
    wget \
  && useradd wine -d /home/wine \
  && mkdir -p /home/wine/.wine \
  && chown -R wine:wine /home/wine \
  && mkdir -p /etc/sudoers.d \
  && echo "wine ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wine

ARG DEBIAN
FROM base

ARG DEBIAN
ARG BRANCH
ARG PACKAGE

ADD https://dl.winehq.org/wine-builds/winehq.key /usr/share/keyrings/winehq.key
RUN cat /usr/share/keyrings/winehq.key | gpg --dearmor > /usr/share/keyrings/winehq.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/winehq.gpg] http://dl.winehq.org/wine-builds/debian/ ${DEBIAN} main" > /etc/apt/sources.list.d/winehq.list \
  && dpkg --add-architecture i386 \
  && apt-get update

RUN apt-get install -y --install-recommends \
  wine-$BRANCH=$PACKAGE \
  wine-$BRANCH-i386=$PACKAGE \
  wine-$BRANCH-amd64=$PACKAGE

RUN apt-get install -y --install-recommends winehq-$BRANCH=$PACKAGE || exit 0

RUN rm -rf /var/lib/apt/lists/*
ADD https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks /usr/local/bin/winetricks
COPY --from=builder /src/pe-set-laa /usr/local/bin/pe-set-laa
COPY profile /etc/profile
COPY ./docker-entrypoint.sh  /usr/local/bin/
RUN chmod -R 755 /usr/local/bin

WORKDIR /home/wine

ENV HOME                      "/home/wine"
ENV DISPLAY                   "unix:0.0"
ENV PULSE_SERVER              "unix:/pulse"
ENV USER_ID                   1000
ENV VIDEO_GID                 44
ENV INPUT_GID                 104
ENV RENDER_GID                105
ENV SET_LAA                   ""
ENV WINEARCH                  "win32"
ENV WINETRICKS                ""
ENV WINEDLLOVERRIDES          ""
ENV JSCAL                     ""
ENV SDL_JOYSTICK_DEVICE       ""
ENV SDL_GAMECONTROLLERCONFIG  ""

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "su", "wine", "-p", "-c", "/bin/bash -l" ]
