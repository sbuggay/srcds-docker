FROM debian:buster-slim

ENV HOME /home/$USER
ENV SERVER $HOME/hlserver

# Steam ID to be injected into sourcemod admin's if sourcemod is installed
ARG STEAM_ID 

RUN set -x \
    && apt-get update \
    && apt-get install -y --no-install-recommends --no-install-suggests \
    lib32stdc++6=8.3.0-6 \
    lib32gcc1=1:8.3.0-6 \
    wget=1.20.1-1.1 \
    ca-certificates=20190110 \
    unzip \
    && apt-get clean autoclean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ADD ./scripts/update.txt $SERVER/update.txt
ADD ./scripts/update.sh $SERVER/update.sh
ADD ./scripts/entry.sh $SERVER/entry.sh
ADD ./cfg/autoexec.cfg $SERVER/csgo/csgo/cfg/autoexec.cfg
ADD ./cfg/server.cfg $SERVER/csgo/csgo/cfg/server.cfg

RUN wget -qO- http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz \
    && $SERVER/update.sh
    
RUN wget -qO- https://mms.alliedmods.net/mmsdrop/1.10/mmsource-1.10.7-git971-linux.tar.gz | tar -C $SERVER/csgo/csgo/ -xvzf -
RUN wget -qO- https://sm.alliedmods.net/smdrop/1.10/sourcemod-1.10.0-git6454-linux.tar.gz | tar -C $SERVER/csgo/csgo/ -xvzf -
RUN wget -qO- https://github.com/splewis/csgo-pug-setup/releases/download/2.0.5/pugsetup_2.0.5.zip -O pugsetup.zip \
    && unzip pugsetup.zip -d $SERVER/csgo/csgo/ \
    && rm pugsetup.zip


RUN if [ -n "$STEAM_ID" ] ; then echo "\"$STEAM_ID\" \"99:z\"" >> csgo/csgo/addons/sourcemod/configs/admins_simple.ini; fi

ADD ./plugins/EnableDisable.smx $SERVER/csgo/csgo/addons/sourcemod/plugins/EnableDisable.smx

EXPOSE 27015/udp 27015/tcp

WORKDIR /home/$USER/hlserver
ENTRYPOINT ["./entry.sh"]
CMD ["-console" "-usercon" "+game_type" "0" "+game_mode" "1" "+mapgroup" "mg_active" "+map" "de_overpass"]