#!/bin/bash

if [ -z "$VNC_PASSWORD" ]; then
	echo >&2 'error: No password for VNC connection set.'
	echo >&2 '  Did you forget to add -e VNC_PASSWORD=... ?'
	exit 1
fi

# first boot X-Server and give it sometime to start up
Xvfb :0 -screen 0 1024x768x24 2>&1 &
sleep 2

# Now we can run the VNC-Server based on our just started X-Server
x11vnc -forever -passwd $VNC_PASSWORD -display :0
