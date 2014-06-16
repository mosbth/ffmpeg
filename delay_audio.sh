#!/bin/sh
INPUT=$1
OUTPUT="sync_$1"
DELAY=$2

ffmpeg -i $INPUT -itsoffset $DELAY -i $INPUT -vcodec copy -acodec copy -map 0:0 -map 1:1 $OUTPUT
vlc $OUTPUT

