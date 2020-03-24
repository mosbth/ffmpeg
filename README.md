Notes on capture and streaming from Debian Linux using ffmpeg
=============================================================

Personal notes and ready to execute scripts that I use when capturing video, audio and screen to produce videos for youtube or when trying to stream to twitch.

```text
$ sudo apt-get install v4l-utils
```



How to configure webcam Debian
-----------------------------------------------------------

I'm using Logitech C920.

Check what devices are arailable.

```text
 v4l2-ctl --list-devices
```

View current setting for one device.

```text
v4l2-ctl --device=0 --list-ctrls
v4l2-ctl --device=0 --list-ctrls-menu
```

Edit settings, for example (last time I updated on my Debian).

```text
v4l2-ctl --device=0 --set-ctrl=exposure_auto=1
v4l2-ctl --device=0 --set-ctrl=exposure_absolute=110
v4l2-ctl --device=0 --set-ctrl=backlight_compensation=1
v4l2-ctl --device=0 --set-ctrl=focus_auto=0
v4l2-ctl --device=0 --set-ctrl=focus_absolute=0
v4l2-ctl --device=0 --set-ctrl=saturation=160
v4l2-ctl --device=0 --set-ctrl=sharpness=160
v4l2-ctl --device=0 --set-ctrl=brightness=110
v4l2-ctl --device=0 --set-ctrl=contrast=128
v4l2-ctl --device=0 --set-ctrl=white_balance_temperature_auto=0
v4l2-ctl --device=0 --set-ctrl=white_balance_temperature=2500
```



Default settings (920C).

```text
v4l2-ctl --device=0 --set-ctrl=brightness=128
v4l2-ctl --device=0 --set-ctrl=contrast=128
v4l2-ctl --device=0 --set-ctrl=saturation=128
v4l2-ctl --device=0 --set-ctrl=white_balance_temperature_auto=1
v4l2-ctl --device=0 --set-ctrl=gain=0
v4l2-ctl --device=0 --set-ctrl=power_line_frequency=2
v4l2-ctl --device=0 --set-ctrl=white_balance_temperature=4000
v4l2-ctl --device=0 --set-ctrl=sharpness=128
v4l2-ctl --device=0 --set-ctrl=backlight_compensation=0
v4l2-ctl --device=0 --set-ctrl=exposure_auto=3
v4l2-ctl --device=0 --set-ctrl=exposure_absolute=250
v4l2-ctl --device=0 --set-ctrl=exposure_auto_priority=0
v4l2-ctl --device=0 --set-ctrl=pan_absolute=0
v4l2-ctl --device=0 --set-ctrl=tilt_absolute=0
v4l2-ctl --device=0 --set-ctrl=focus_auto=1
v4l2-ctl --device=0 --set-ctrl=focus_absolute=0
v4l2-ctl --device=0 --set-ctrl=zoom_absolute=100
```

Current settings on my Logitech C920 on Debian Sid.

```text
$ v4l2-ctl --device=0 --list-ctrls-menu
                     brightness 0x00980900 (int)    : min=0 max=255 step=1 default=128 value=110
                       contrast 0x00980901 (int)    : min=0 max=255 step=1 default=128 value=128
                     saturation 0x00980902 (int)    : min=0 max=255 step=1 default=128 value=160
 white_balance_temperature_auto 0x0098090c (bool)   : default=1 value=0
                           gain 0x00980913 (int)    : min=0 max=255 step=1 default=0 value=0
           power_line_frequency 0x00980918 (menu)   : min=0 max=2 default=2 value=2
                                0: Disabled
                                1: 50 Hz
                                2: 60 Hz
      white_balance_temperature 0x0098091a (int)    : min=2000 max=6500 step=1 default=4000 value=2500
                      sharpness 0x0098091b (int)    : min=0 max=255 step=1 default=128 value=160
         backlight_compensation 0x0098091c (int)    : min=0 max=1 step=1 default=0 value=1
                  exposure_auto 0x009a0901 (menu)   : min=0 max=3 default=3 value=1
                                1: Manual Mode
                                3: Aperture Priority Mode
              exposure_absolute 0x009a0902 (int)    : min=3 max=2047 step=1 default=250 value=110
         exposure_auto_priority 0x009a0903 (bool)   : default=0 value=0
                   pan_absolute 0x009a0908 (int)    : min=-36000 max=36000 step=3600 default=0 value=0
                  tilt_absolute 0x009a0909 (int)    : min=-36000 max=36000 step=3600 default=0 value=0
                 focus_absolute 0x009a090a (int)    : min=0 max=250 step=5 default=0 value=0
                     focus_auto 0x009a090c (bool)   : default=1 value=0
                  zoom_absolute 0x009a090d (int)    : min=100 max=500 step=1 default=100 value=100
```



Audio / Microphone
------------------------------------------------------------

List connected PCI devices.

```text
lspci -v
```

Install essentials.

```text
sudo apt-get install audacity
sudo apt-get install alsa-utils
```

List devices.

```text
cat /proc/asound/cards
aplay -L
arecord -l
```

Set level of input for the mic ([reference](http://www.massyn.net/completed/recording-with-the-rode-podcaster-on-linux/
)).

```text
cat /proc/asound/cards # Check what cardno
amixer -c <cardno>
amixer -c <cardno> set Mic 32 # or set to max
```

Set default input/output device ([reference](https://wiki.archlinux.org/index.php/PulseAudio/Examples#Set_default_input_sources)).

```text
pacmd list-sources | grep -e device.string -e 'name:' # get input device
pacmd list-sinks | grep -e 'name:' -e 'index:'        # get output device

sudo vim /etc/pulse/default.pa
```

```text
### Make some devices default
#set-default-sink output
#set-default-source input
set-default-source alsa_input.usb-RODE_MICROPHONESj_Rode_Podcaster-00.analog-mono
set-default-sink alsa_output.pci-0000_00_1b.0.iec958-stereo.monitor               
```

Restart PulseAudio

```text
pulseaudio -k
pulseaudio --start
```


Uncertain if this is needed.

```text
sudo alsactl init
sudo alsactl store
alsamixer
```



Delay audio
------------------------------------------------------------

Delay audio to sync with video.

```text
$ ./delay_audio.sh ~/a6.mp4 0.2
```



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


Grab desktop
--------------------

https://trac.ffmpeg.org/wiki/How%20to%20grab%20the%20desktop%20(screen)%20with%20FFmpeg

ffmpeg -framerate 24 -video_size 1920x1080 -f x11grab -i :0.0+0,0 -f alsa -ac 2 -i pulse -vcodec libx264 -crf 0 -preset ultrafast -acodec pcm_s16le output.flv
ffmpeg -i output.flv -acodec ... -vcodec ... final.flv



Grab raw and then decode
desktop:~> ffmpeg -f x11grab -framerate 30 -video_size hd1080 -i :0.0+2560,400 -vcodec libx264 out.mkv ; ffmpeg -i out.mkv -vcodec libx264 -crf 22 out.mp4

vlc --fullscreen out.mp4



Grab cam
-----------------------------------

desktop:~/capture> ffmpeg -f video4linux2 -s 1980x1020 -i /dev/video0 -r 24 -vcodec libx264 -y cam.mkv ; ffmpeg -i cam.mkv -vcodec libx264 -crf 22 -y cam.mp4 ; vlc --fullscreen cam.mp4




Grab audio
--------------------------------

### Set default input device.

Useful when skype does not work with the mic.

```
# List available resources
pacmd list-sources | grep -e device.string -e 'name:'

# For tempory use as default device
pacmd "set-default-source alsa_input.usb-RODE_MICROPHONESj_Rode_Podcaster-00.analog-mono"

# Another way
pacmd "load-module module-alsa-source source_name=rode device=hw:1"
pacmd "set-default-source rode"
```

Eventually set default input device in config-file, copy from /etc/pulse/default.pa and store in .pulse (?)
