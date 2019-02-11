#! /bin/bash

if [[ -z "${INITIAL_USERNAME}" ]]; then
  INITIAL_USERNAME="user"
fi

if [[ -z "${INITIAL_VNC_PASSWORD}" ]]; then
  INITIAL_VNC_PASSWORD="userland"
fi

if [ ! -f /home/$INITIAL_USERNAME/.vnc/passwd ]; then
x11vnc -storepasswd $INITIAL_VNC_PASSWORD ~/.vnc/passwd
fi

Xvfb :51 -screen 0 800x640x24 &
x11vnc -xkb -noxrecord -noxfixes -noxdamage -display :51 -N -usepw -shared &
VNC_PID=$!
echo $VNC_PID > /home/$INITIAL_USERNAME/.vnc/localhost:51.pid

cd ~
DISPLAY=localhost:51 xterm -geometry 80x24+0+0 -e /bin/bash --login &
