#!/bin/sh
INPUT=$1
START=$2
STOP=$3

[ -f  "$INPUT" ] || ( echo "Usage: command filename delay"; exit 2 )

dir=$(dirname "$INPUT")
filename=$(basename "$INPUT")
extension="${filename##*.}"
filename="${filename%.*}"
OUTPUT="$dir/${filename}_cut${START}_${STOP}.$extension"


ffmpeg -ss $START -i "$INPUT" -to $STOP -async 1 -c copy "$OUTPUT"

vlc "$OUTPUT"
