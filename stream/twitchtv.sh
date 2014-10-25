#!/bin/bash

INRES="1920x1080"
TOPXY="2560,400"
GOP="60"
GOPMIN="30"
OUTRES="1920x1080"
FPS="30"
THREADS="0"
QUALITY="ultrafast"
CBR="1000k"
WEBCAM="/dev/video0"
WEBCAM_WH="320:240"
SERVER="live-fra"
AUDIO_RATE="44100"
LOGLEVEL_ARG=""
STREAM_KEY=$(cat ~/.twitch_key)

#ffmpeg -f x11grab -s $INRES -framerate "$FPS" -i :0.0+$TOPXY -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p -s $OUTRES -preset $QUALITY -tune film  -acodec libmp3lame -threads $THREADS -vf "movie=$WEBCAM:f=video4linux2, scale=$WEBCAM_WH , setpts=PTS-STARTPTS [WebCam]; [in] setpts=PTS-STARTPTS, [WebCam] overlay=main_w-overlay_w-10:10 [out]" -strict normal -bufsize $CBR $LOGLEVEL_ARG "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"

#ffmpeg -f x11grab -s $INRES -framerate "$FPS" -i :0.0+$TOPXY -f alsa -i pulse -f flv -ac 2 -ar $AUDIO_RATE -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p -s $OUTRES -preset $QUALITY -tune film  -acodec libmp3lame -threads $THREADS -vf "movie=$WEBCAM:f=video4linux2, scale=$WEBCAM_WH , setpts=PTS-STARTPTS [WebCam]; [in] setpts=PTS-STARTPTS, [WebCam] overlay=main_w-overlay_w-10:10 [out]" -strict normal -bufsize $CBR $LOGLEVEL_ARG "rtmp://$SERVER.twitch.tv/app/$STREAM_KEY"


VIDEO="-f x11grab -s $INRES -r $FPS -i :0.0+4480,400"

#AUDIO="-f alsa -i pulse -f flv -ac 2 -ar 44100 -ab 96k -acodec libmp3lame"
#AUDIO="-f alsa -i pulse -ac 2 -ar 44100 -ab 96k -acodec libmp3lame"
#AUDIO="-f alsa -i plughw:2,0 -ac 2 -ar 44100 -ab 96k -acodec libmp3lame"
AUDIO="-f alsa -ac 2 -i plughw:2,0 -ar 44100 -ab 96k"
#AUDIO=""

#-crf 22
CONSTANT="-g 60 -keyint_min 30 -b:v $CBR -minrate $CBR -maxrate $CBR"
CONSTANT="" 
CONSTANT="-g $GOP -keyint_min $GOPMIN  -b:v $CBR -minrate $CBR -maxrate $CBR"

WEBCAMON="-vf \"movie=$WEBCAM:f=video4linux2, scale=$WEBCAM_WH, setpts=PTS-STARTPTS [WebCam]; [in] setpts=PTS-STARTPTS, [WebCam] overlay=main_w-overlay_w-10:10 [out]\""

CAM="-f v4l2 -video_size 320x240 -r $FPS -i /dev/video0"

#ffmpeg  -f x11grab -s 1920x1080 -r 30 -i ":0.0+4480,400"  $AUDIO -f flv -vcodec libx264 $CONSTANT  -preset ultrafast -pix_fmt yuv420p -s 1920x1080 -threads 0 -tune film -strict normal -bufsize $CBR "rtmp://live-arn.twitch.tv/app/$STREAM_KEY"
     

CAMFILTER="-filter_complex \"[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=W-w-10:10,format=yuv420p[out]\" map \"[out]\" -map 2:a"
CAMFILTER=""

#ffmpeg -f x11grab -s "$INRES" -r "$FPS" -i ":0.0+4480,400" $CAM $AUDIO $CAMFILTER -vcodec libx264 -g $GOP -keyint_min $GOPMIN -b:v $CBR -minrate $CBR -maxrate $CBR -pix_fmt yuv420p -s $OUTRES -preset $QUALITY -tune film -acodec libmp3lame -f flv -threads $THREADS $WEBCAMON -strict normal -bufsize $CBR "rtmp://live-arn.twitch.tv/app/$STREAM_KEY"



 #ffmpeg $VIDEO $CAM $AUDIO -filter_complex "[0:v]scale=1024:-1,setpts=PTS-STARTPTS[bg]; [1:v]scale=120:-1,setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=W-w-10:10,format=yuv420p[out]" -map "[out]" -map 2:a -vcodec libx264 -preset veryfast -maxrate $CBR -bufsize $CBR -acodec libmp3lame  -f flv rtmp://live.justin.tv/app/$STREAM_KEY

  ffmpeg $VIDEO $CAM $AUDIO -filter_complex "[0:v]scale=1920:-1,setpts=PTS-STARTPTS[bg]; [1:v]scale=320:-1,setpts=PTS-STARTPTS[fg]; [bg][fg]overlay=W-w-10:10,format=yuv420p[out]" -map "[out]" -map 2:a -vcodec libx264 -preset veryfast -maxrate $CBR -bufsize $CBR -acodec libmp3lame  -f flv rtmp://live.justin.tv/app/$STREAM_KEY