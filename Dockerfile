FROM debian:buster-slim

ARG METAMOD=true
ARG SOURCEMOD=true
ARG PLUGINS=true
ARG STEAM_ID
ARG RCON_PASSWORD

RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6 \
    lib32gcc1 \
    libcurl4-gnutls-dev:i386 \
    ca-certificates \
    wget \
    unzip \
    vim \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -d /home/steam steam && \
    chown -R steam /home/steam

USER steam

ENV SERVER $HOME/hlserver
ENV AUTOEXEC $SERVER/csgo/csgo/cfg/autoexec.cfg
ENV APP_ID 740

COPY --chown=steam scripts $SERVER/

RUN ./$SERVER/install-steamcmd.sh

# Patch the following error:
# /home/steam/.steam/sdk32/steamclient.so: cannot open shared object file: No such file or directory
RUN	mkdir -p /home/steam/.steam/sdk32 \
  && ln -s /home/steam/steamcmd/linux32/steamclient.so /home/steam/.steam/sdk32/steamclient.so


ADD ./cfg/autoexec.cfg $AUTOEXEC
ADD ./cfg/server.cfg $SERVER/csgo/csgo/cfg/server.cfg

# Generate autoupdate script
RUN { \
			echo "@ShutdownOnFailedCommand 1"; \
			echo "@NoPromptForPassword 1"; \
			echo "login anonymous"; \
			echo "force_install_dir ${SERVER}"; \
			echo "app_update ${APP_ID}"; \
			echo "quit"; \
		} > ${SERVER}/update.txt

RUN if [ "$METAMOD" = true ] ; then ./$SERVER/install-metamod.sh ; fi
RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] ; then ./$SERVER/install-sourcemod.sh ; fi
RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] && [ "$PLUGINS" = true ] ; then ./$SERVER/install-plugins.sh ; fi
RUN if [ "$METAMOD" = true ] && [ "$SOURCEMOD" = true ] && [ -n "$STEAM_ID" ] ; then ./$SERVER/sourcemod-admin.sh ; fi

ADD ./plugins/EnableDisable.smx $SERVER/csgo/csgo/addons/sourcemod/plugins/EnableDisable.smx

WORKDIR $SERVER
ENTRYPOINT ["./entry.sh"]