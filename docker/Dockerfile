FROM i386/debian:bullseye-slim

ENV USER_ID    1000
ENV AUDIO_GID  29
ENV VIDEO_GID  44
ENV WINETRICKS ""

RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y \
  sudo \
  wine32 \
  pulseaudio \
  wget \
  unzip \
  cabextract

ADD https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks /usr/bin/winetricks
RUN chmod 755 /usr/bin/winetricks

RUN useradd wine -d /home/wine \
  && mkdir -p /home/wine/.wine \
  && chown -R wine:wine /home/wine \
  && echo "wine ALL=(ALL:ALL) NOPASSWD: ALL" > /etc/sudoers.d/wine

WORKDIR /home/wine

COPY profile /etc/profile
COPY ./docker-entrypoint.sh  /usr/local/bin/
RUN chmod -R 755 /usr/local/bin

ENTRYPOINT [ "/usr/local/bin/docker-entrypoint.sh" ]
CMD [ "su", "wine", "-p", "-c", "/bin/bash -l" ]
