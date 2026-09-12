#!/bin/bash

if ! [ "$(ping -c 1 google.com)" ]; then
    truncate -s '<10M' /home/jetson/wifi_check_log.txt
    echo -e "Warning: connection lost at $(date) -- restart" >> /home/jetson/wifi_check_log.txt
    ip link set wlan0 down
    sleep 5
    ip link set wlan0 up
    sleep 5
    if ! [ "$(ping -c 1 google.com)" ]; then
         echo -e "Waiting for connection going up at $(date)" >> /home/jetson/wifi_check_log.txt
    else
         echo -e "Connection on at $(date)" >> /home/jetson/wifi_check_log.txt
    fi
else
    echo -e "Connection OK at $(date)" >> /home/jetson/wifi_check_log.txt
fi
