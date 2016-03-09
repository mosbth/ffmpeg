#!/bin/bash
#
# Capture cam, screen and audio as three separate files and 
# postprocess in video editor.
#
# Notes on installation (TBD):
#  apt-get install alsa-utils
#
# List devices
#  video
#   v4l2-ctl --list-devices
#
#  sound
#   arecord -l
#   alsamixer # to check its status
#   pactl # another way to list info on devices
#   pactl list sources
#
# Editor
#  apt-get install blender
#



#
# Load the config file
#
CONFIG_FILE=capture.config
if [ ! -f $CONFIG_FILE ]; then
    echo "Missing config file: 'capture.config'"
    exit 1
fi
. $CONFIG_FILE

echo "Using settings: "
echo " Video device = $VIDEO_DEVICE"
echo " Audio device = $AUDIO_DEVICE"
echo " Screen area  = $SCREEN_AREA"
echo


#
# Move previos files to archive for short term backup
#
echo "Moving existing clips to archive."

if [ ! -d archive ]; then
    echo "Missing directory 'archive'."
    exit 1
fi

cp -f cam.mkv scr.mkv aud.wav archive/
rm -f cam.mkv scr.mkv aud.wav aud_normalized.wav aud_original.wav
echo


#
# Settings for cam
#
echo "Settings for cam."
#v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1
v4l2-ctl --device=$VIDEO_DEVICE --get-fmt-video
#v4l2-ctl --set-parm=30
v4l2-ctl --device=$VIDEO_DEVICE --get-parm
echo


#
# Settings for mic
#
echo "Settings for mic."
amixer -c 2 set Mic 32
#amixer -c 2
echo


#
# Capture 
#
#ffmpeg -y -f video4linux2 -s 1920x1080 -i /dev/video0 -vcodec libx264 cam.mkv  > /dev/null 2>&1 &
#ffmpeg -y -f video4linux2 -s 1920x1080 -i /dev/video0 -vcodec libx264 -preset ultrafast -qp 0 cam.mkv  > /dev/null 2>&1 &

# Capture cam as cam.mkv
echo -n "Grabbing cam.mkv..."
ffmpeg -y -f video4linux2 -s 1920x1080 -pix_fmt h264 -framerate 30 -i $VIDEO_DEVICE cam.mkv &> /dev/null &
camPid=$!
echo " ($camPid)"

# Capture screen as src.mkv
echo -n "Grabbing scr.mkv..."
ffmpeg -y -f x11grab -framerate 30 -video_size hd1080 -i $SCREEN_AREA -vcodec libx264 -preset ultrafast -qp 0 scr.mkv  &> /dev/null &
scrPid=$!
echo " ($scrPid)"

# Capture audio as aud.wav
echo -n "Grabbing aud.wav..."
ffmpeg -y -f $AUDIO_TYPE -ac 1 -ar 44100 -i $AUDIO_DEVICE aud.wav &> /dev/null &
audPid=$!
echo " ($audPid)"
echo

# Pause until done
read -p "Press any key to stop recording."
echo
kill $camPid $scrPid $audPid
#pkill ffmpeg
#ps aux | grep ffmpeg | awk '{print $2}' | xargs kill
echo "Sleeping 5 to wait until capture dies."
sleep 5 
echo



#
# Normalize audio
#
./normalize-audio.bash



# Encode
#ffmpeg -i cam.mkv -vcodec libx264 -crf 22 -y cam.mp4
#ffmpeg -i scr.mkv -vcodec libx264 -crf 22 -y scr.mp4

#
# Get details of each clip
#
for clip in "cam.mkv" "scr.mkv" "aud.wav"; do
    if [ -f $clip ]; then
        echo -n "$clip "
        ffmpeg -i $clip 2>&1 | grep Duration
    fi
done
echo
echo


#
# Do postprocess and edit video
#
#vlc --fullscreen cam.mp4
#openshot cam.mp4 scr.mp4 aud.wav
#openshot cam.mkv scr.mkv aud.wav
#kdenlive -i cam.mkv,scr.mkv,aud.wav proj
echo "Postprocess using: $VIDEO_EDITOR"
exec $VIDEO_EDITOR  &> /dev/null
