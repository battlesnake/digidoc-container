#!/bin/sh

set -xeu

export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

pcscd -fd & pid=$!

trap 'kill "$pid"' EXIT

sleep 3

if [ -z "${1:-}" ]; then
	set digidoc
fi

uid="${UID:-1000}"
gid="${GID:-1000}"

groupadd -g "$gid" notroot || true
useradd -u "$uid" -g "$gid" -m notroot

chown "$uid:$gid" /home/notroot /home/notroot/ext /home/notroot/.digidocpp

command="$1"
shift

sudo="sudo -u notroot -D /home/notroot/ext --"

case "$command" in

digidoc) $sudo qdigidoc4;;

browser) $sudo firefox;;

run) $sudo "$@";;

*) echo "Unknown command: $command" >&2; exit 1;;

esac
