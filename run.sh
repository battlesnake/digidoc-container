#!/bin/bash

set -e

declare err=0

if pgrep -f pcscd &>/dev/null; then
    echo ''
    echo 'PCSCD is currently running'
    echo ''
    echo 'Please stop pcscd first (sudo systemctl stop pcscd)'
    echo ''
    err=1
fi

if ! touch -c /dev/bus/usb/001/001 &>/dev/null; then
    echo ''
    echo 'Failed to touch USB device node'
    echo ''
    echo 'You will probably have trouble detecting/accessing the USB card reader'
    echo ''
    echo 'Temporarily change the permissions (sudo chmod +666 /dev/bus/usb/*/*), or add a udev rule'
    echo ''
    err=1
fi

if (( err )); then
    read -n 1 -p 'Continue anyway? ' yn
    echo ''
    if [ "$yn" != y ]; then
        echo 'Aborting due to errors'
        echo ''
        exit 1
    fi
fi

xhost local:root

if ! docker image inspect markkc/digidoc &>/dev/null; then
    docker build -t markkc/digidoc docker/
fi

docker run \
    --rm \
    -it \
	-v "${HOME}:/home/notroot/ext" \
	-v "/tmp/.X11-unix:/tmp/.X11-unix" \
	-v "${HOME}/.Xauthority:/home/notroot/.Xauthority" \
	-v "${XDG_RUNTIME_DIR}:/run/xdg-runtime-dir" \
	-v "/dev/bus/usb:/dev/bus/usb" \
	-v "/run/udev:/run/udev:ro" \
	-e DISPLAY="$DISPLAY" \
	-e XDG_RUNTIME_DIR=/run/xdg-runtime-dir \
	--privileged \
	--network host \
	markkc/digidoc \
    --su "$(id -u)" "$(id -g)" "$(hostname)" \
    -- \
	"$@"
