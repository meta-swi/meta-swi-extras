#!/bin/sh
# Copyright 2012 Sierra Wireless
#
# M2M specific applications start or stop here

source /etc/run.env

uart_get_srv

UART1_SRV=$UART1_SERVICE
UART2_SRV=$UART2_SERVICE

case "$1" in
    start)
        # Starts diag_uart_log if the UART1 is mapped for diagnostic service
        if  [ d${UART1_SRV} = "dDM" ]; then
          swi_log "Mapped UART1 for diagnostics service"
          /usr/bin/diag_uart_log -d /dev/ttyHSL0 > /dev/null &
        elif [ d${UART2_SRV} = "dDM" ]; then
          swi_log "Mapped UART2 for diagnostics service"
          /usr/bin/diag_uart_log -d /dev/ttyHSL1 > /dev/null &
        fi
        
        TYPE=`bsinfo -st`
        if  [ t${TYPE} = 't09' ] || [ t${TYPE} = 't0A' ] || [ t${TYPE} = 't0B' ] || [ t${TYPE} = 't1C' ] || [ t${TYPE} = 't1D' ] || [ t${TYPE} = 't1E' ] ; then
          # WP710x detected
          # Enable mass storage polling
          echo 1 > /sys/devices/platform/msm_sdcc.1/polling &
          
          # Mount SD card if present
          echo /dev/mmcblk0> /sys/devices/platform/msm_hsusb/gadget/lun0/file
        fi
        
        ;;
    monitor)
        if  [ d${UART1_SRV} = "dDM" -o d${UART2_SRV} = "dDM" ]; then
          if [ $(ps | grep -v grep | grep diag_uart_log | wc -l) -eq 0 ]; then
            killall -q -HUP diag_uart_log
            if [ d${UART1_SRV} = "dDM" ]; then
              /usr/bin/diag_uart_log -d /dev/ttyHSL0 > /dev/null &
            elif [ d${UART2_SRV} = "dDM" ]; then
              /usr/bin/diag_uart_log -d /dev/ttyHSL1 > /dev/null &
            fi
          fi
        else
          if [ $(ps | grep -v grep | grep diag_uart_log | wc -l) -eq 1 ]; then
            killall -q -HUP diag_uart_log
          fi        
        fi
        ;;
    stop)
        killall -q -HUP diag_uart_log
        ;;
    *)
        exit 1
        ;;
esac

exit 0
