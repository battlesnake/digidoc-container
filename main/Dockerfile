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
	| bash -x

run env SUDO_FORCE_REMOVE=yes apt remove -y sudo

run groupadd -g 1000 notroot
run useradd -u 1000 -g 1000 -m notroot

run chmod +777 /var/run

copy start.sh /

user notroot

entrypoint ["/start.sh"]
