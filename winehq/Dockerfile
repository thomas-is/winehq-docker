ARG DEBIAN=bookworm

FROM i386/debian:$DEBIAN-slim

ARG DEBIAN=bookworm
ENV USER_ID         1000
ENV VIDEO_GID       44
ENV INPUT_GID       104
ENV WINETRICKS      "isolate_home"

RUN apt-get update \
  && apt-get install -y \
    ca-certificates \
    cabextract \
    gnupg \
    mesa-vulkan-drivers \
    pulseaudio \
    sudo \
    unzip \
    vulkan-tools \
    wget

ADD https://dl.winehq.org/wine-builds/winehq.key /usr/share/keyrings/winehq.key
RUN cat /usr/share/keyrings/winehq.key | gpg --dearmor > /usr/share/keyrings/winehq.gpg \
  && echo "deb [signed-by=/usr/share/keyrings/winehq.gpg] http://dl.winehq.org/wine-builds/debian/ ${DEBIAN} main" > /etc/apt/sources.list.d/winehq.list
RUN cat /etc/apt/sources.list.d/winehq.list

RUN apt-get update \
  && apt-get install -y --install-recommends winehq-devel \
  && rm -rf /var/lib/apt/lists/*

ADD https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks /usr/bin/winetricks
RUN chmod 755 /usr/bin/winetricks

RUN useradd wine -d /home/wine \
  && mkdir -p /home/wine/.wine \
  && chown -R wine:wine /home/wine \
  && mkdir -p /etc/sudoers.d \
  && echo "wine ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wine

WORKDIR /home/wine

COPY profile /etc/profile
COPY ./docker-entrypoint.sh  /usr/local/bin/
RUN chmod -R 755 /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "su", "wine", "-p", "-c", "/bin/bash -l" ]
