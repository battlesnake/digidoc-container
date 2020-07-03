#!/bin/sh

set -eu

export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

pcscd -fd & pid=$!

trap "kill $pid" EXIT

sleep 3

cd /home/notroot/ext/

if [ -z "${1:-}" ]; then
	set digidoc
fi

command="$1"
shift

case "$command" in

digidoc) qdigidoc4;;

browser) firefox;;

run) "$@";;

*) echo "Unknown command: $command" >&2; exit 1;;

esac
