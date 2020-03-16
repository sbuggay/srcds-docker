#!/bin/sh
cd $HOME

installPlugin () {
    wget -qO- $1 -O tempplugin.zip
    unzip -o tempplugin.zip -d $SERVER/csgo/csgo/
    rm tempplugin.zip
}

enablePlugin () {
    mv $SERVER/csgo/csgo/addons/sourcemod/plugins/disabled/$1 $SERVER/csgo/csgo/addons/sourcemod/plugins/
}

disablePlugin () {
    mv $SERVER/csgo/csgo/addons/sourcemod/plugins/$1 $SERVER/csgo/csgo/addons/sourcemod/plugins/disabled/
}

installPlugin https://github.com/splewis/csgo-pug-setup/releases/download/2.0.5/pugsetup_2.0.5.zip
installPlugin https://github.com/splewis/csgo-practice-mode/releases/download/1.3.3/practicemode_1.3.3.zip
installPlugin https://github.com/splewis/csgo-multi-1v1/releases/download/1.1.9/multi1v1_1.1.9.zip
installPlugin https://github.com/Maxximou5/csgo-deathmatch/raw/master/deathmatch.zip

disablePlugin pugsetup.smx
disablePlugin practicemode.smx
disablePlugin deathmatch.smx
disablePlugin multi1v1.smx