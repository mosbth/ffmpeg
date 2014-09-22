#!/bin/bash

#Settingb for cam
#v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1
v4l2-ctl --get-fmt-video
#v4l2-ctl --set-parm=30
v4l2-ctl --get-parm

# Settings for mic
amixer -c 2 set Mic 32
#amixer -c 2


#rm files
cp cam.mkv scr.mkv aud.wav archive/
rm -f cam.mkv scr.mkv aud.wav


#Capture 
#ffmpeg -y -f video4linux2 -s 1920x1080 -i /dev/video0 -vcodec libx264 cam.mkv  > /dev/null 2>&1 &
#ffmpeg -y -f video4linux2 -s 1920x1080 -i /dev/video0 -vcodec libx264 -preset ultrafast -qp 0 cam.mkv  > /dev/null 2>&1 &

ffmpeg -y -f video4linux2 -s 1920x1080 -pix_fmt h264 -r 30 -i /dev/video0 cam.mkv > /dev/null 2>&1 &
ffmpeg -y -f x11grab -framerate 30 -video_size hd1080 -i :0.0+4480,400 -vcodec libx264 -preset ultrafast -qp 0 scr.mkv  > /dev/null 2>&1 &
ffmpeg -y -f alsa -ac 2 -i plughw:2,0 aud.wav > /dev/null 2>&1 &


#Pause until done
read -p "Press any key to stop recording."
pkill ffmpeg
#ps aux | grep ffmpeg | awk '{print $2}' | xargs kill
echo "Sleeping 5 to wait until capture dies."
sleep 5 


# Encode
#ffmpeg -i cam.mkv -vcodec libx264 -crf 22 -y cam.mp4
#ffmpeg -i scr.mkv -vcodec libx264 -crf 22 -y scr.mp4


#vlc --fullscreen cam.mp4
#openshot cam.mp4 scr.mp4 aud.wav
openshot cam.mkv scr.mkv aud.wav


