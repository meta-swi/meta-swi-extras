#!/bin/sh
# Copyright 2012 Sierra Wireless
#
# Starts the amix and aplay arec in the background

action="$1";
fname="$2";

if [ "$action" = "audio" ]
  then
      echo "Starting aplay audio file: "
      aplay $fname
fi

if [ "$action" = "dtmf" ]
  then
      echo "Starting aplay dtmf: "
      #   find the index of DTMF RX Hostless null-codec-dai
      #  00-??: DTMF RX Hostless null-codec-dai-? :  : playback 1 : capture 1
      pcm_id=`grep "DTMF RX" /proc/asound/pcm | cut -b 4-5`
      echo PCM port id $pcm_id
      aplay -D hw:0,$((pcm_id+0)) -P & 
fi
