#!/bin/bash

function show_stats() {
  rate=`grep "present rate" /proc/acpi/battery/BAT0/state | awk '{print $3}'`
  date=`date +%Y-%m-%d\ %H:%M`
  cpu=`grep 'cpu MHz' /proc/cpuinfo | awk '{print $4}'`
  echo $date,$cpu,$rate
}
  

if [[ "%1" == "peek" ]]; then
  show_stats
else
  while [[ 1 ]]; do
    show_stats
    sleep 5
  done
fi

