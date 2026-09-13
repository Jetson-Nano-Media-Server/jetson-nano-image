set positional-arguments := true

default:
    @just --list --unsorted

install-prerequisites:
    -@scripts/install-prerequisites.sh

build-jetson-rootfs *args="": install-prerequisites
    -@scripts/build-base-rootfs.sh {{ args }}

build-jetson-image *args="":
    -@scripts/build-jetson-image.sh {{ args }}

flash-jetson-image Jetson-image:
    @scripts/flash-jetson-image.sh {{ Jetson-image }}

clean:
    rm -rf base rootfs
    podman rmi -a -f
    sudo podman rmi -a -f
    sudo rm -rf jetson.img
