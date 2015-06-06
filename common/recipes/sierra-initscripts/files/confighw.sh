#!/bin/sh
# Copyright 2012 Sierra Wireless
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

# Avoid unnecessary error printing
if [ -e "/sys/module/kernel/parameters/ldo5" ]; then
	# WP710x devices detected
	if [ t${TYPE} = 't09' ] || [ t${TYPE} = 't0A' ] || [ t${TYPE} = 't0B' ] || [ t${TYPE} = 't1C' ] || [ t${TYPE} = 't1D' ] || [ t${TYPE} = 't1E' ] ; then
		# LDO5 is needed for UART2
		LDO5VAL=1
	fi

	echo ${LDO5VAL} > /sys/module/kernel/parameters/ldo5
fi

# Provide helper to access tty for AT
if [ -e "/dev/smd8" ] && ! [ -e "/dev/ttyAT" ]; then
	ln -s "/dev/smd8" "/dev/ttyAT"
fi

