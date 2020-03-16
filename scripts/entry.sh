#!/bin/sh

# Inject hostname if it's not already in the autoexec
if [ $AUTOEXEC ] && ! cat $AUTOEXEC | grep -q hostname; then
    SERVER_HOSTNAME="${SERVER_HOSTNAME:-Counter-Strike: Global Offensive Dedicated Server}"
    sed -i -e "\$ahostname \"$SERVER_HOSTNAME\"" $AUTOEXEC
fi

csgo/srcds_run -game csgo -autoupdate -steam_dir $SERVER -steamcmd_script $SERVER/update.txt $@
