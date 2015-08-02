#!/bin/bash

CONFIG="/tmp/.sing_config"
if [ ! -f $CONFIG ]; then
 echo 'LAST_S=' >> $CONFIG
 echo 'LAST_A=' >> $CONFIG
 echo 'LAST_V=' >> $CONFIG
fi

LAST_S=$(cat $CONFIG | grep "LAST_S=" | sed -E 's/LAST_S=//')
LAST_A=$(cat $CONFIG | grep "LAST_A=" | sed -E 's/LAST_A=//')
LAST_V=$(cat $CONFIG | grep "LAST_V=" | sed -E 's/LAST_V=//')

echo -n "Enter song [$LAST_S]: "
read s
if [[ $s = "" ]]; then
 song=$LAST_S
else
 song=$(echo $s | tr '[:upper:]' '[:lower:]' | sed 's/\ /-/g')
 sed -iE 's/LAST_S=.*/LAST_S='$song'/' $CONFIG
fi

echo -n "Enter artist [$LAST_A]: "
read a
if [[ $a = "" ]]; then
 artist=$LAST_A
else
 artist=$(echo $a | tr '[:upper:]' '[:lower:]' | sed 's/\ /-/g')
 sed -iE 's/LAST_A=.*/LAST_A='$artist'/' $CONFIG
fi

echo -n "Enter voice (type help for a list of voices) [$LAST_V]: "
 read v
while [[ $v = "help" ]]; do
 say -v ?
 echo -n "Enter voice (type help for a list of voices) [$LAST_V]: "
 read v
done
if [[ $v = "" ]]; then
 voice=$LAST_V
else
 voice=$v
 sed -iE 's/LAST_V=.*/LAST_V='$v'/' $CONFIG
fi

echo "Now singing $song by $artist in the voice of $voice (hit ctrl+c to cancel)..."
# curl -s http://www.songlyrics.com/$artist/$song-lyrics/ | tr -d '\r\n' | grep -oE '<p id="songLyricsDiv".*?>.*?</p>' | perl -pe 's|<br />| |g' | perl -pe 's|<.*?>||g' | say -v $voice
curl -s http://www.metrolyrics.com/$song-lyrics-$artist.html | tr -d '\r\n' | grep -oE '<div id="lyrics-body-text">.*?</div>' | perl -pe 's|<br />| |g' | perl -pe 's|<.*?>||g' | say -v $voice
