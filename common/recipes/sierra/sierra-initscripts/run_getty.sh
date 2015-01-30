#!/bin/sh
# Copyright 2014 Sierra Wireless
#
# start getty

source /etc/run.env

uart_get_srv

if [ ${UART1_SERVICE} = "CONSOLE" ]; then
  swi_log "UART1 reserved for CONSOLE"
  /sbin/getty ttyHSL0 115200 console
elif [ ${UART2_SERVICE} = "CONSOLE" ]; then
  swi_log "UART2 reserved for CONSOLE"
  /sbin/getty ttyHSL1 115200 console
else
  swi_log "No UART mapped to CONSOLE"

  # This script is run from inittab and will be respawned 
  # by init if it exits. That is why blocking call is needed 
  # to prevent exit from happening
  cat /dev/tty1
fi

