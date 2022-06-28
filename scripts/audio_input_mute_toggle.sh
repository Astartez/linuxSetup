#!/bin/bash

# Mute state for default source: yes/no
default_source_mute_state=$(pactl get-source-mute $(pactl get-default-source) | awk '{ print $2 }')

source_name_list=$( pactl list short sources | awk '!/.monitor/{ print $2 }' )

if [[ $default_source_mute_state = "no" ]]; then
    # I MUST MUTE
    for source_name in $source_name_list;do
        pactl set-source-mute $source_name 1
    done
    notify-send "Microphone: Muted" --icon=audio-input-microphone
else
    # I MUST UNMUTE
    for source_name in $source_name_list;do
        pactl set-source-mute $source_name 0
    done
    notify-send "Microphone: Unmuted" --icon=audio-input-microphone
fi
