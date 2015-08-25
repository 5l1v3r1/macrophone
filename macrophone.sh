#!/bin/bash
# Description:  A program to tell your Mac to read (i.e. "sing") a song of your choosing.
# Author:       Caleb Gross
# Note:         Used a custom associative array implementation since Bash v3 doesn't have
#               one by default, and it appears that's what Macs are shipped with.
#               KEY=${ARRAY%%=*}
#               VALUE=${ARRAY#*=}

# set config file location and settings parameters
CONFIG="/tmp/.macrophone_config"
SETTINGS=(
    "SONG="
    "ARTIST="
    "VOICE="
    )

# wrapper for retrieving settings
# $1 : type      (song|artist|voice)    
# $2 : formatted (optional)
get() {

    if   [ $1 = song ];   then INDEX=0;
    elif [ $1 = artist ]; then INDEX=1;
    elif [ $1 = voice ];  then INDEX=2;
    fi

    if [[ "$#" -gt 1 && $2 = "formatted" && $1 != voice ]]; then
        echo ${SETTINGS[$INDEX]#*=} | sed 's/\ /-/g'
    else
        echo ${SETTINGS[$INDEX]#*=} | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1'
    fi
    
}

if [[ "$#" -eq 3 ]]; then
    SETTINGS[0]=SONG=$(echo $1 | tr '[:upper:]' '[:lower:]')
    SETTINGS[1]=ARTIST=$(echo $2 | tr '[:upper:]' '[:lower:]')
    SETTINGS[2]=VOICE=$(echo $3 | tr '[:upper:]' '[:lower:]')
else

    # read settings from config file if it already exists
    # otherwise, create a new blank config file
    if [ -f $CONFIG ]
        then
        for (( i=0; i<${#SETTINGS[@]}; i++ ))
        do
            LINE=$( grep "${SETTINGS[i]}" $CONFIG )
            VALUE=${LINE#*=}
            SETTINGS[i]=${SETTINGS[i]}$VALUE
        done
    else
        printf '%s\n' "${SETTINGS[@]}" > $CONFIG
    fi

    # prompts to be displayed to user
    PROMPTS=(
        "SONG&Enter song [$(get song)]: "
        "ARTIST&Enter artist [$(get artist)]: "
        "VOICE&Enter voice (for a list of voices, type help) [$(get voice)]: "
        )

    # prompt user for input
    # if they enter a new selection, process it
    # otherwise, use selection from config file
    for (( i=0; i<${#PROMPTS[@]}; i++ ))
    do
        TYPE=${PROMPTS[i]%%&*}
        PROMPT=${PROMPTS[i]#*&}
        echo -n "$PROMPT "
        read INPUT
        while [[ $TYPE = "VOICE" && $INPUT = "help" ]]; do
            say -v ?
            echo -n "$PROMPT "
            read INPUT
        done
        if [[ $INPUT != "" ]]
            then
            SELECTION=$(echo $INPUT | tr '[:upper:]' '[:lower:]')
            SETTINGS[i]=$TYPE=$SELECTION
        fi
    done

    # save current selections
    printf '%s\n' "${SETTINGS[@]}" > $CONFIG

fi

# printf '%s\n' "${SETTINGS[@]}"

# print feedback to user
echo "Now singing $(get song) by $(get artist) in the voice of $(get voice) (hit ctrl+c to cancel)..."

# sing selected song
curl -s http://www.metrolyrics.com/$(get song formatted)-lyrics-$(get artist formatted).html |\
tr -d '\r\n' |\
grep -oE '<div id="lyrics-body-text">.*?</div>' |\
perl -pe 's|<br />| |g' |\
perl -pe 's|<.*?>||g' |\
say -v "$(get voice)"
