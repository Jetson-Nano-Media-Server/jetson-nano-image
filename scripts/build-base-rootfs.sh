#!/usr/bin/env bash

# Authors: Badr @pythops, Milan @milantodorovic

set -e

echo "Building base rootfs"

CPU_CORES=$(nproc)

if [ "$1" != "20.04" ]; then
  echo "Error: Unknow version of ubuntu. The supported versions are: 20.04, 21.04, 22.04, 23.04, 24.04"
  exit 1
fi

case $1 in
"20.04")
  podman build \
    --squash-all \
    --jobs=$CPU_CORES \
    --arch=arm64 \
    --network=host \
    -f Containerfile.rootfs.20_04 \
    -t jetson-rootfs
  ;;
*)
  exit 1
  ;;
esac

podman save --format docker-dir -o base jetson-rootfs

# If for whatever reason the build fails the first time, a rootfs dir is created
#   then the build fails at this step if we don't delete and remake it
rm -rf rootfs && mkdir -p rootfs

for layer in "$(jq -r '.layers[].digest' base/manifest.json | awk -F ':' '{print $2}')"; do
  tar xvf base/"$layer" --directory=rootfs
done

rm -rf rootfs/root/.bash_history

rm -rf base

echo "Rootfs created in rootfs directory"
