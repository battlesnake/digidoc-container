from ubuntu:focal

env DEBIAN_FRONTEND=noninteractive
env LANG=en_GB.UTF-8
env LC_ALL=en_GB.UTF-8
env TZ=Europe/Tallinn
run ln -fs /usr/share/zoneinfo/Europe/Tallinn /etc/localtime

run apt update
run apt install -y wget lsb-release gnupg build-essential sudo firefox

run echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

run wget -O - https://installer.id.ee/media/install-scripts/install-open-eid.sh \
	| sed -e '/^test_root$/d' \
	| sed -e 's/chrome-token-signing-policy//' \
	| sed -e 's/apt-get install /apt-get install -y /' \
	| sed -e 's/read -p /read <<<n -p /' \
	| bash -x

# run env SUDO_FORCE_REMOVE=yes apt remove -y sudo

run chmod +777 /var/run

entrypoint ["/start.sh"]

copy start.sh /
