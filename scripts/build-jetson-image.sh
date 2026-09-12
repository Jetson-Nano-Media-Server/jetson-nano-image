#!/usr/bin/env bash

# Authors: Badr @pythops, Milan @milantodorovic

set -e

CPU_CORES=$(nproc)
l4t=32

supported_boards=("jetson-nano" "jetson-nano-2gb")

function usage() {
    echo "Usage: $0 -b <board> -r <revision> -d <device>"
    echo ""
    echo "board: the board name, one of the following names:"
    for supported_board in "${supported_boards[@]}"; do
        echo "    ${supported_board}"
    done
    echo ""
    echo "revision: the revision number. The possible values are: 100, 200 or 300."
    echo ""
    echo "device: B01"
    echo ""
    echo "l4t version. The possible value is: 32"
    exit 1
}

while getopts b:r:d:h opts; do
    case "$opts" in

    b)
        board=${OPTARG}
        if [[ ! " ${supported_boards[@]} " =~ " ${board} " ]]; then
            printf "\e[31mError: Unsupported board: %s \n\e[0m" "$board"
            echo "The supported boards are:"
            for supported_board in "${supported_boards[@]}"; do
                echo "- ${supported_board}"
            done
            exit 1
        fi
        ;;

    r)
        revision=${OPTARG}
        ;;

    d)
        device=${OPTARG}
        ;;

    h)
        usage
        ;;

    *) usage ;;
    esac
done

if [ "$board" = "" ]; then
    printf "\e[31mError: board argument in required.\e[0m \n\n"
    usage
fi

case $board in
"jetson-nano")
    if [[ "$revision" != "100" && "$revision" != "200" && "$revision" != "300" ]]; then
        printf "\e[31mError: Unknown revision for Jetson nano board.\n\e[0m"
        echo "Supported revision: 100, 200 or 300"
        exit 1
    fi
    ;;
*) ;;
esac

L4T_PACKAGES=""

if [[ -f "l4t_packages.txt" ]]; then
    while IFS= read -r line; do
        if [[ ${line} != \#* ]]; then
            L4T_PACKAGES+=" $line"
        fi
    done <"l4t_packages.txt"
fi

L4T_PACKAGES="${L4T_PACKAGES# }"

sudo -E XDG_RUNTIME_DIR= DBUS_SESSION_BUS_ADDRESS= podman build \
    --cap-add=all \
    --jobs=$CPU_CORES \
    --network=host \
    --build-arg L4T_PACKAGES="$L4T_PACKAGES" \
    -f Containerfile.image.l4t"$l4t" \
    -t jetson-build-image-l4t"$l4t"

sudo podman run \
    --rm \
    --network=host \
    --privileged \
    -v .:/jetson \
    -e JETSON_BOARD="$board" \
    -e JETSON_DEVICE="$device" \
    -e JETSON_REVISION="$revision" \
    localhost/jetson-build-image-l4t"$l4t":latest \
    create-jetson-image.sh
