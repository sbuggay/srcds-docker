#!/bin/sh
time wget -qO- http://media.steampowered.com/client/steamcmd_linux.tar.gz | tar -C $SERVER -xvz && $SERVER/update.sh