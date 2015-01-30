#!/bin/sh
# Copyright (c) 2014 Sierra Wireless
#

case "$1" in
    start)
        # Enable the autosleep feature
        if [ -f /sys/power/autosleep ]
        then
            # Don't do this until USB issues are all resolved
            #echo mem > /sys/power/autosleep
            true
        fi
        ;;
    stop)
        ;;
    *)
        exit 1
        ;;
esac

exit 0
