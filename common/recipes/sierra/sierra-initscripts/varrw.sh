#!/bin/sh
# Copyright (c) 2012 Sierra Wireless
#

# DM, FIXME: We probably do not need this.
exit 0

# use /home as a temporary mount point
TEMP_DIR="/home"

case "$1" in
    start)
        # mount read/write var on TEMP_DIR
        mount -t tmpfs var ${TEMP_DIR}
        # copy readonly /var directory to the temporary directory
        cp -R /var/* ${TEMP_DIR}
        # remount read/write var to /var
        mount -o move ${TEMP_DIR} /var
        ;;
    stop)
        umount /var
        ;;
    *)
        exit 1
        ;;
esac

exit 0
