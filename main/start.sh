#!/bin/sh

set -e

export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

pcscd -fd & pid=$!

trap "kill $pid" EXIT

sleep 3

cd /home/notroot/ext/

qdigidoc4
