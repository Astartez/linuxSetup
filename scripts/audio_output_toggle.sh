#!/bin/bash

# User variables. See "pactl list sinks"
sink_name="alsa_output.pci-0000_00_1b.0.analog-stereo"
sink_port_headset="analog-output-lineout"
sink_port_speakers="analog-output-headphones"

current_audio_output=$( pactl list sinks | awk '/Active Port:/{ print $NF }' )
if [[ $current_audio_output == $sink_port_speakers ]]; then
    pactl set-sink-port $sink_name $sink_port_headset
    notify-send "Audio output: Headset" --icon=audio-volume-high
else
    pactl set-sink-port $sink_name $sink_port_speakers
    notify-send "Audio output: Speaker" --icon=audio-volume-high
fi
