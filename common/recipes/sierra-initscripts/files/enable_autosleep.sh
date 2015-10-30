#!/bin/sh
# Copyright (c) 2014 Sierra Wireless
#

DEVICE=/dev/usb_link

case "$1" in
    start)
        if [ -x /usr/bin/epollwakeup ]
        then
            echo "${DEVICE}" > /sys/power/wake_lock
            echo -n "Starting epollwakeup: "
            start-stop-daemon -S -b -a /usr/bin/epollwakeup -- ${DEVICE}
            echo "done"
        fi

        # Enable the autosleep feature
        if [ -f /sys/power/autosleep ]
        then
            echo mem > /sys/power/autosleep
            true
        fi
        ;;
    stop)
        echo off > /sys/power/autosleep
        echo -n "Stopping epollwakeup: "
        start-stop-daemon -K -n epollwakeup
        echo "done"
        ;;
    restart)
        $0 stop
        $0 start
        ;;
    *)
        exit 1
        ;;
esac

exit 0
