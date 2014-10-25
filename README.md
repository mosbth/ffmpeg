Notes on capture and streaming from Debian Linux using ffmpeg
=============================================================

Personal notes and ready to execute scripts that I use when capturing video, audio and screen to produce videos for youtube or when trying to stream to twitch.



Notes
-------------------------------------------------------------

vlc -vvv v4l2:///dev/video0

sudo apt-get install openshot 

http://www.oz9aec.net/index.php/gstreamer/473-using-the-logitech-c920-webcam-with-gstreamer

sudo apt-get install v4l-utils

v4l2-ctl --all

desktop:~> v4l2-ctl --list-devices
HD Pro Webcam C920 (usb-0000:00:14.0-13):
        /dev/video0

desktop:~> v4l2-ctl --set-fmt-video=width=1920,height=1080,pixelformat=1
desktop:~> v4l2-ctl --get-fmt-video
Format Video Capture:
        Width/Height  : 1920/1080
        Pixel Format  : 'H264'
        Field         : None
        Bytes per Line: 3840
        Size Image    : 4147200
        Colorspace    : SRGB

desktop:~> v4l2-ctl --set-parm=30
Frame rate set to 30.000 fps

desktop:~> v4l2-ctl --set-parm=24
Frame rate set to 24.000 fps
desktop:~> 

#vlc --fullscreen cam.mp4




Twitch.tv
--------------
https://github.com/wargio/Twitch-Streamer-Linux
http://devram0.blogspot.it/2013/10/twitch-streamer-for-linux.html


Grap desktop
--------------------

https://trac.ffmpeg.org/wiki/How%20to%20grab%20the%20desktop%20(screen)%20with%20FFmpeg

ffmpeg -framerate 24 -video_size 1920x1080 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i pulse -vcodec libx264 -crf 0 -preset ultrafast -acodec pcm_s16le output.flv
ffmpeg -i output.flv -acodec ... -vcodec ... final.flv



Grab raw and then decode
desktop:~> ffmpeg -f x11grab -framerate 30 -video_size hd1080 -i :0.0+2560,400 -vcodec libx264 out.mkv ; ffmpeg -i out.mkv -vcodec libx264 -crf 22 out.mp4

vlc --fullscreen out.mp4



Grap cam
-----------------------------------

desktop:~/capture> ffmpeg -f video4linux2 -s 1980x1020 -i /dev/video0 -r 24 -vcodec libx264 -y cam.mkv ; ffmpeg -i cam.mkv -vcodec libx264 -crf 22 -y cam.mp4 ; vlc --fullscreen cam.mp4




Audio
--------------------------------

lspci -v

sudo alsactl init

aplay -L

alsamixer
sudo alsactl store


Grab audio
--------------------------------

sudo apt-get install audacity

arecord -l

http://www.massyn.net/completed/recording-with-the-rode-podcaster-on-linux/
sätt nivån på inspelningsljudet i micken

amixer -c 2 set Mic 32


