#!/bin/bash
#
# Normalize the audio to 0 dB when detecting negative dB values.
#

src=${1:-aud.wav}

dir=$(dirname "$src")
filename=$(basename "$src")
extension="${filename##*.}"
filename="${filename%.*}"
target="$dir/${filename}_norm.$extension"

echo -n "Analyzing src=''$src'"
db=$( ffmpeg -i "$src" -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1 )
echo " detected $db dB"

if [ "$( echo "$db < 0" | bc )" -eq 1 ]; then
    echo "Normalising '$src' using ${db#?}dB..."
    ffmpeg -i "$src" -af "volume=${db#?}dB" -c:v copy "$target" -loglevel quiet

    echo -n "Analyzing result='$target'"
    db=$( ffmpeg -i "$target" -af "volumedetect" -f null /dev/null 2>&1 | grep max_volume | awk -F': ' '{print $2}' | cut -d' ' -f1 )
    echo " detected $db dB"
    ls -l "$src" "$target"
    echo vlc \"$src\"
    echo vlc \"$target\"
else
    echo "Ignore normalising."
fi
