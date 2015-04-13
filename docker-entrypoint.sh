#!/bin/bash

# first start the X-Server
Xvfb :1 -screen 0 1024x768x24 &> ~/xvfb.log &

# Now we can run the VNC-Server based on our just started X-Server
x11vnc -forever -usepw -display :1 -N
