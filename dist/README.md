I get sick of DigiDoc never working whenever I or my partner need to sign something.
Whether on my Arch or Ubuntu PCs, or her Windows PCs, Digidoc always seems to find ways to break when we need to use it urgently.
So I've containerised it in an attempt to mitigate that.


To prepare
==========

Save the following docker-compose configuration somewhere, for use in step #2 of starting the container.

```
version: '2'
services:
  main:
    image: markkc/digidoc
    user: notroot
    volumes:
     - ${HOME}:/home/notroot/ext
     - /tmp/.X11-unix:/tmp/.X11-unix
     - ${HOME}/.Xauthority:/home/notroot/.Xauthority
     - ${XDG_RUNTIME_DIR}:/run/xdg-runtime-dir
     - /dev/bus/usb:/dev/bus/usb
     - /run/udev:/run/udev:ro
    environment:
     - DISPLAY
     - XDG_RUNTIME_DIR=/run/xdg-runtime-dir
    privileged: true
    restart: "no"
    network_mode: "host"
```

This has been tested on Arch Linux.  For other distros, you may need to alter `volume`/`environment` paths for X11-related things on the host.
This binds your home-directory from the host into the container at `~/ext/`, under the assumption that the files you will want to sign/verify will be under your home directory.  If this is not the case, you will need to alter that volume path.

To start
========

1. Plug ID card reader in and insert ID card.

2. Run (where `<CONFIG>` is the path of the docker-compose file that you created in the "To prepare" step):

```
# Note that this runs the container in privileged mode!
docker-compose -f <CONFIG> up
```

3. Go through DigiDoc intro screens, wait for it to connect to PCSCD and detect ID card (shown in top of DigiDoc).

4. You're good to go.  DigiDoc can browse to your home directory via the "ext" directory within the container user's home directory.

5. When you're done, close DigiDoc.  The container will exit after a few seconds.


Issues
======

## If DigiDoc fails to connect to X11

Try running (before re-starting the container):

```
xhost local:root
```

This should not be necessary for most people but might help in weird configurations.


## If PCSCD can't take control of the USB device

Most likely:

 * Docker is not running the container in "privileged mode"

 * You aren't using udev on the host, or it is configured in a strange way

 * You have PCSCD (or some other smartcard daemon) on the host already taking control of the cardreader before the container's PCSCD instance can do so.

