#!/bin/sh
INPUT=$1
DELAY=$2

dir=$(dirname "$INPUT")
filename=$(basename "$INPUT")
extension="${filename##*.}"
filename="${filename%.*}"
OUTPUT="$dir/${filename}_syncv$DELAY.$extension"

ffmpeg -i $INPUT -itsoffset $DELAY -i $INPUT -vcodec copy -acodec copy -map 0:1 -map 1:0 $OUTPUT
vlc $OUTPUT
