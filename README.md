To start
========

1. Plug ID card reader in and insert ID card.

3. Run:

```
# Note that this runs the container in privileged mode
docker-compose --build up
```

4. Go through DigiDoc intro screens, wait for it to connect to PCSCD and detect ID card (shown in top of DigiDoc).

5. You're good to go.  DigiDoc can browse to your home directory via the "ext" directory within the container user's home directory.

6. When you're done, close DigiDoc.  The container will exit after a few seconds.


Issues
======

## If DigiDoc fails to connect to X11

Try running:

```
xhost local:root
```

This should not be necessary but might help in weird configurations.


## If PCSCD can't take control of the USB device

Either:

 * Docker is not running the container in "privileged mode"

 * You aren't using udev

 * You have PCSCD (or some other smartcard daemon) on the host already taking control of the cardreader before the container's PCSCD instance can do so.

Either way, fix your setup.

