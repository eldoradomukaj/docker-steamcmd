FROM ubuntu:latest

ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMDIR "${HOMEDIR}/steamcmd"

RUN dpkg --add-architecture i386 \
  && apt update \
  && apt install -y --no-install-recommends --no-install-suggests \
  sudo \
  libsdl2-2.0-0:i386 \
  lib32stdc++6 \
  lib32gcc1 \
  ca-certificates \
  wget \
  locales \
  && sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
  && dpkg-reconfigure --frontend=noninteractive locales \
  && useradd -u ${PUID} -m ${USER} \
  && echo "${USER} ALL=(ALL:ALL) NOPASSWD: ALL" >> /etc/sudoers \
  && mkdir -p ${STEAMDIR} \
  && wget -qO- 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C "${STEAMDIR}" \
  && chown -R ${USER}:${USER} ${STEAMDIR} \
  && su "${USER}" -c "./${STEAMDIR}/steamcmd.sh +quit" \
  && apt remove --purge -y wget \
  && apt clean autoclean \
  && apt autoremove -y \
  && rm -rf /var/lib/apt/lists/*

USER ${USER}
WORKDIR ${STEAMDIR}
VOLUME ${STEAMDIR}