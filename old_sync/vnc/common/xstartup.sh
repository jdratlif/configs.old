#! /bin/sh

unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS

export XKL_XMODMAP_DISABLE=1

xrdb -cpp /usr/bin/cpp $HOME/.Xresources
xsetroot -solid grey
i3 &
