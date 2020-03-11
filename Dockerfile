FROM ubuntu:bionic

ARG METAMOD=true
ARG SOURCEMOD=true
ARG PLUGINS=true
ARG STEAM_ID
ARG RCON_PASSWORD

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6 \
    lib32gcc1 \
    ca-certificates \
    wget \
    unzip \
    vim \
    ranger \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash steam
USER steam

ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

COPY --chown=steam scripts $SERVER/

# RUN wget -qO- http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz && $SERVER/update.sh

# Patch the following error:
# /home/steam/.steam/sdk32/steamclient.so: cannot open shared object file: No such file or directory
# RUN	mkdir -p /home/steam/.steam/sdk32 \
  # && ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so

# ADD ./cfg/autoexec.cfg $SERVER/csgo/csgo/cfg/autoexec.cfg
# ADD ./cfg/server.cfg $SERVER/csgo/csgo/cfg/server.cfg

# RUN if [ "$METAMOD" = true ] ; then ./$SERVER/install-metamod.sh ; fi
# RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] ; then ./$SERVER/install-sourcemod.sh ; fi
RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] && [ "$PLUGINS" = true ] ; then ./$SERVER/install-plugins.sh ; fi
# RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] && [ -n "$STEAM_ID" ] ; then ./$SERVER/sourcemod-admin.sh ; fi

# ADD ./plugins/EnableDisable.smx $SERVER/csgo/csgo/addons/sourcemod/plugins/EnableDisable.smx

WORKDIR /home/$USER/hlserver
ENTRYPOINT ["./entry.sh"]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_dust2" "-tickrate" "128"]