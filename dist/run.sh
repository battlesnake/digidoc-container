#!/bin/bash

set -e

docker run \
	--user notroot \
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
	"$@"
