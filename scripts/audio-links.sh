#!/bin/bash

# Ensure devices are properly reset
pw-cli destroy "Arctis Chat"
pw-cli destroy "Arctis Media"

# Create virtual sinks for both Chat and Media channels
pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="Arctis Chat" node.description="Arctis Chat" monitor.channel-volumes=true media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'
pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name="Arctis Media" node.description="Arctis Media" monitor.channel-volumes=true media.class=Audio/Sink object.linger=true audio.position=[FL FR] }'

sleep 1s

# Link virtual sinks to default sink for the headset
pw-link "Arctis Chat:monitor_FL" "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo:playback_FL"
pw-link "Arctis Chat:monitor_FR" "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo:playback_FR"

pw-link "Arctis Media:monitor_FL" "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo:playback_FL"
pw-link "Arctis Media:monitor_FR" "alsa_output.usb-SteelSeries_Arctis_7_-00.analog-stereo:playback_FR"
