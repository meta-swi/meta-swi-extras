#!/bin/sh

#Copyright (c) 2012 Qualcomm Technologies, Inc.  All Rights Reserved.
#Qualcomm Technologies Proprietary and Confidential.

port=rmnet0

echo 'modem offline' | qmi_simple_ril_test modem_port=$port &
sleep 1

