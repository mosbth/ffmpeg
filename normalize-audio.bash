#!/bin/bash
#
# Normalize the audio to 0 dB when detecting negative dB values.
#


echo -n "Analyzing..."
db=$( ffmpeg -i aud.wav -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1 )
echo " detected $db dB"

if [ "$( echo "$db < 0" | bc )" -eq 1 ]; then
    echo "Normalising using ${db#?}dB..."
    ffmpeg -i aud.wav -af "volume=${db#?}dB" -c:v copy aud_normalized.wav -loglevel quiet
    cp aud.wav aud_original.wav
    cp aud_normalized.wav aud.wav
    
    echo -n "Analyzing..."
    db=$( ffmpeg -i aud.wav -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1 )
    echo " detected $db dB"

else
    echo "Ignore normalising."
fi
