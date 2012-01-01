#!/bin/bash

rate=`grep "present rate" /proc/acpi/battery/BAT0/state | awk '{print $3}'`
date=`date +%Y-%m-%d\ %H:%M`

echo $date,$rate
