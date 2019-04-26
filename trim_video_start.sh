#!/bin/sh
INPUT=$1
START=$2

[ -f  "$INPUT" ] || ( echo "Usage: command filename delay"; exit 2 )

dir=$(dirname "$INPUT")
filename=$(basename "$INPUT")
extension="${filename##*.}"
filename="${filename%.*}"
OUTPUT="$dir/${filename}_cut${START}.$extension"


ffmpeg -ss $START -i "$INPUT" -async 1 -c copy "$OUTPUT"

vlc "$OUTPUT"
