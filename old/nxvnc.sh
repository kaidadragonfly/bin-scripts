#!/bin/sh

VNC_VIEWER=vncviewer
VNC_SERVER=x11vnc
VNC_RESOLUTION=1024x786
VNC_PASSWD=/home/USER/.vnc/passwd
VNC_PORT=5900

if [ -z "$(pgrep ${VNC_SERVER})" ]; then
	echo $VNC_SERVER not running, starting...
	exec $VNC_SERVER &
	sleep 5
fi

exec $VNC_VIEWER -geometry $VNC_RESOLUTION -passwd $VNC_PASSWD localhost::$VNC_PORT
