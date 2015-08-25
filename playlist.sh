#!/bin/bash

PLAYLIST_FILE=~/Music/iTunes/iTunes\ Music\ Library.xml

promptPlaylist() {
	echo -n "Enter playlist name (for a list of playlists, type help): "
	read PLAYLIST
}
promptVoice() {
	echo -n "Enter voice (for a list of voices, type help): "
	read VOICE
}

promptPlaylist
while [[ $PLAYLIST = "help" ]]; do
	cat "$PLAYLIST_FILE" \
	| grep -B 1 -oE "<key>(Smart Info|Playlist Items)</key>" \
	| grep string \
	| perl -pe 's|.*?<string>(.*?)</string>.*?|\1|g'
	promptPlaylist
done

promptVoice
while [[ $VOICE = "help" ]]; do
    say -v ?
    promptVoice
done

echo "Now retrieving songs from $PLAYLIST. Please wait..."
SONG_IDS=$(cat "$PLAYLIST_FILE" \
| tr -d '\n' \
| grep -oE "<key>Name</key><string>$PLAYLIST</string>.*?<array>.*?</array>" \
| perl -pe 's|.*?<array>(.*?)</array>.*|\1|' \
| perl -pe 's|\D+| |g' 
)

SONG_IDS=($SONG_IDS)
# printf "%s\n" "${SONG_IDS[@]}"
SONGS=()
for ID in "${SONG_IDS[@]}"
do
	SONG=$(grep -oE "(<key>$ID</key>|<key>(Name|Artist)</key><string>.*?</string>)" "$PLAYLIST_FILE" \
	| grep -A 2 "$ID" \
	| grep string \
	| tr -d '\n' \
	| perl -pe 's|.*<string>(.*?)</string>.*?<string>(.*?)</string>|"\1" "\2"|g')
	SONG_NAME=$(echo $SONG | awk -F\" '{print $(NF-3)}')
	SONG_ARTIST=$(echo $SONG | awk -F\" '{print $(NF-1)}')
	./macrophone.sh "$SONG_NAME" "$SONG_ARTIST" "$VOICE"
done