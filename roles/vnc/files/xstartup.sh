#!/bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

if [ -x /usr/bin/i3 ]; then
    /usr/bin/i3
elif [ -x /usr/bin/mate-session ]; then
    /usr/bin/mate-session
elif [ -x /usr/bin/startxfce4 ]; then
    /usr/bin/startxfce4
fi

vncserver -kill $DISPLAY
