#!/bin/sh

set -xeu

export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

pcscd -fd & pid=$!

trap "kill $pid" EXIT

sleep 3

if [ -z "${1:-}" ]; then
	set digidoc
fi

groupadd -g "${GID:-1000}" notroot
useradd -u "${UID:-1000}" -g "${GID:-1000}" -m notroot

cd /home/notroot/ext/

command="$1"
shift

case "$command" in

digidoc) sudo -Eu notroot -- qdigidoc4;;

browser) sudo -Eu notroot -- firefox;;

run) sudo -Eu notroot -- "$@";;

*) echo "Unknown command: $command" >&2; exit 1;;

esac
