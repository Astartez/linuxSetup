#!/bin/bash

if [ $( amixer set Capture toggle | awk '/Front Left:/{ print $NF }' ) == "[on]" ]; then
    notify-send "Microphone: Unmuted" --icon=audio-input-microphone
else
    notify-send "Microphone: Muted" --icon=audio-input-microphone
fi

