#!/bin/sh
cd $HOME/steam

echo $PWD

wget -qO- https://github.com/splewis/csgo-pug-setup/releases/download/2.0.5/pugsetup_2.0.5.zip -O pugsetup.zip
unzip -o pugsetup.zip -d $SERVER/csgo/csgo/
rm pugsetup.zip

wget -qO- https://github.com/splewis/csgo-practice-mode/releases/download/1.3.3/practicemode_1.3.3.zip -O practicemode.zip
unzip -o practicemode.zip -d $SERVER/csgo/csgo/
rm practicemode.zip
mv $SERVER/csgo/csgo/addons/sourcemod/plugins/practicemode.smx $SERVER/csgo/csgo/addons/sourcemod/plugins/disabled/

