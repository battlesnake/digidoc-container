#!/bin/sh

set -eu

if ! [ -e /.dockerenv ]; then
    echo ''
    echo 'This script is intended to be run from within a docker container'
    echo ''
    echo 'IT IS EXTREMELY DANGEROUS TO RUN THIS SCRIPT ON THE HOST!'
    echo ''
    echo 'Aborting'
    exit 1
fi

if [ "x${1:-}" = 'x--debug' ]; then
    set -x
    shift
fi

export PATH=/usr/local/sbin:/usr/sbin:/sbin:/usr/local/bin:/usr/bin:/bin

if [ "x${1:-}" = 'x--su' ]; then
    shift
    uid="$1"
    shift
    gid="$1"
    shift
    hostname="$1"
    shift
    if [ "$1" != '--' ]; then
        echo 'Invalid syntax'
        exit 1
    fi
    shift
    sed -i -e "s/^.*:x:$gid:.*$//" /etc/group
    sed -i -e "s/^.*:x:$uid:.*$//" /etc/passwd
    groupadd -g "$gid" notroot
    useradd -u "$uid" -g "$gid" -M notroot
    chown notroot:notroot /home/notroot
    printf "\n127.0.0.1  $hostname\n" >> /etc/hosts
    exec sudo -u notroot -g notroot -- "$0" "$@"
fi

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
