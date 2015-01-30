#!/bin/sh
# Copyright 2012 Sierra Wireless
# DM, FIXME: Have other copy in common/recipes/sierra/sierra-initscripts/confighw.sh, why?
#
# TYPE contains h/w type
TYPE=`bsinfo -st`

LDO5VAL=0

if [ t${TYPE} = 't02' ]; then
	# MHS detected
	LDO5VAL=1
	modprobe sierra-mhs
	modprobe ebi2_lcd
	modprobe ili9341
	modprobe tsc2007
fi
if [ t${TYPE} = 't08' ]; then
	# USB detected
	modprobe sierra-usb
	modprobe spi_qsd
	modprobe sh1106
fi
# WP710x devices detected
if [ t${TYPE} = 't09' ] || [ t${TYPE} = 't0A' ] || [ t${TYPE} = 't0B' ] || [ t${TYPE} = 't1C' ] || [ t${TYPE} = 't1D' ] || [ t${TYPE} = 't1E' ] ; then
  # LDO5 is needed for UART2
  LDO5VAL=1
fi

# Avoid unnecessary error printing
f=/sys/module/kernel/parameters/ldo5
if [ -e ${f} ] ; then echo ${LDO5VAL} > ${f} ; fi
