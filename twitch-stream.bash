#! /bin/bash

# input resolution, currently fullscreen.
# you can set it manually in the format "WIDTHxHEIGHT" instead.
INRES=$(xwininfo -root | awk '/geometry/ {print $2}'i)

# output resolution.
# keep the aspect ratio the same or your stream will not fill the display.
OUTRES="1920x1080"

# input audio. You can use "/dev/dsp" for your primary audio input.
INAUD="pulse"

# target fps
FPS="30"

# video preset quality level.
# more FFMPEG presets avaiable in /usr/share/ffmpeg
QUAL="fast"

# stream key. You can set this manually, or reference it from a hidden file like what is done here.
STREAM_KEY=$(cat .twitch_key)

# stream url. Note the formats for twitch.tv and justin.tv
# twitch:"rtmp://live.twitch.tv/app/$STREAM_KEY"
# justin:"rtmp://live.justin.tv/app/$STREAM_KEY"
STREAM_URL="rtmp://live.twitch.tv/app/$STREAM_KEY"



#ffmpeg \
#-f alsa -ac 2 -i "$INAUD" \
#-f x11grab -s "$INRES" -r "$FPS" -i :0.0 \
#-vcodec libx264 -s "$OUTRES" -vpre "$QUAL" \
#-acodec libmp3lame -threads 6 -qscale 5 -b 64KB \
#-f flv -ar 44100 "$STREAM_URL"

# 

ffmpeg \
-f alsa -ac 2 -i "$INAUD" \
-f x11grab -video_size hd1080 -i :0.0+4480,400 -framerate 30 \
-vcodec libx264 -s "$OUTRES" -preset ultrafast \
-acodec libmp3lame -threads 6 -qscale 5 -b 64KB \
-f flv -ar 44100 "$STREAM_URL"
