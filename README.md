Motivation
==========

I get sick of DigiDoc never working whenever I or my partner need to sign something.
Whether on my Arch or Ubuntu PCs, or her Windows PCs, Digidoc always seems to find ways to break when we need to use it urgently.
Likewise, for the in-browser ID card usage.
So I've containerised it all in an attempt to mitigate that.


This has been tested on Arch Linux.  For other distros, you may need to alter `volume`/`environment` paths for X11-related things on the host.
The `run.sh` script binds your home-directory from the host into the container at `~/ext/`, under the assumption that the files you will want to sign/verify will be under your home directory.  If this is not the case, you will need to alter that volume path.


To start Digidoc
================

1. Plug ID card reader in and insert ID card.

3. Run: `./run.sh` to build+start

4. Go through DigiDoc intro screens, wait for it to connect to PCSCD and detect ID card (shown in top of DigiDoc).

5. You're good to go.  DigiDoc can browse to your home directory via the "ext" directory within the container user's home directory.

6. When you're done, close DigiDoc.  The container will exit after a few seconds.


To start Firefox (with ID card extensions pre-installed)
========================================================

1. Plug ID card reader in and insert ID card.

2. Run the script `./run.sh browser`

3. Firefox will start, and has the necessary extensions for ID-card usage pre-installed and enabled

5. When you're done, close DigiDoc.  The container will exit after a few seconds.


## Issues: If PCSCD can't take control of the USB device

Most likely:

 * Docker is not running the container in "privileged mode" for some reason

 * The `/dev/bus/usb/*/*` devices do not permit write access.  An insecure, but temporary solution to this is `sudo chmod +666 /dev/bus/usb/*/*`.  Another solution is to set up appropriate udev rules, so that USB devices are accessible to your user account by default.

 * You aren't using udev on the host, or it is configured in a strange way

 * You have PCSCD (or some other smartcard daemon) on the host already taking control of the cardreader before the container's PCSCD instance can do so.
