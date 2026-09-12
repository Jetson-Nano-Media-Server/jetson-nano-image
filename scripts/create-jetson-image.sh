#!/usr/bin/env bash

# Author: Badr @pythops

case "$JETSON_BOARD" in
jetson-nano-2gb)
    printf "Create image for Jetson nano 2GB board \n"
    sudo ./jetson-disk-image-creator.sh -o jetson_nano_ubuntu20.img -b jetson-nano-2gb-devkit
    cp jetson_nano_ubuntu20.img /jetson/
    printf "[OK]\n"
    ;;

jetson-nano)
    printf "Creating image for Jetson nano board (%s revision) \n" "$JETSON_REVISION"
    sudo ./jetson-disk-image-creator.sh -o jetson_nano_ubuntu20.img -b jetson-nano -r "$JETSON_REVISION"
    cp jetson_nano_ubuntu20.img /jetson/
    printf "[OK]\n"
    ;;

*)
    printf "\e[31mUnsupported Jetson board. \e[0m\n"
    exit 1
    ;;
esac
