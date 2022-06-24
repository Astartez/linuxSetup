#!/usr/bin/env python3
from time import sleep
import subprocess
import re

# User variables. See "pactl list sinks"
sink_name="alsa_output.pci-0000_00_1b.0.analog-stereo"
sink_port_headset="analog-output-lineout"
sink_port_speakers="analog-output-headphones"
monitor_period_seconds=0.5

# Mysterious problem: audio output gets set to the speaker on its own
# 
# This icky band-aid fixes this by monitoring the current output and setting it to the headset if it has changed
while True:
    sinks_output = subprocess.run(["pactl", "list", "sinks"], capture_output=True, universal_newlines=True).stdout
    if (re.search('Active Port: (.*)', sinks_output).group(1) == sink_port_speakers):
        subprocess.run(["pactl", "set-sink-port", sink_name, sink_port_headset])
        print("SPEAKER DETECTED.. REVERTING!")
    sleep(monitor_period_seconds)
