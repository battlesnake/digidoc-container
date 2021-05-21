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
	| sed -e 's/^read -p "Would you like to activate Chrome.*$/policy=n/' \
	| sed -e 's/apt-get install /apt-get install -y /' \
	| bash -x

run chmod +777 /var/run

run mkdir -p /home/notroot/.digidocpp
run mkdir -p /home/notroot/ext

copy start.sh /

entrypoint ["/start.sh"]
