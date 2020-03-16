#!/bin/sh

# Inject hostname if it's not already in the autoexec
if [ ! grep -q hostname ../cfg/autoexec.cfg ];then
    SERVER_HOSTNAME="${SERVER_HOSTNAME:-Counter-Strike: Global Offensive Dedicated Server}"
    echo not found
fi

csgo/srcds_run -game csgo -autoupdate -steam_dir $SERVER -steamcmd_script $SERVER/update.txt $@