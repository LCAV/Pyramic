#!/bin/bash -x

# locale
localedef -i en_US -c -f UTF-8 en_US.UTF-8
dpkg-reconfigure locales

# timezone
echo "Europe/Zurich" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

# hostname
echo DE1-SoC > /etc/hostname
cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   DE1-SoC
EOF

# network interfaces
cat <<EOF > /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet static
address 10.42.0.2
netmask 255.255.255.0
gateway 10.42.0.1
EOF

# enable serial console for login shell
cat <<EOF > /etc/init/ttyS0.conf
# ttyS0 - getty
#
# This service maintains a getty on ttyS0

description "Get a getty on ttyS0"

start on runlevel [2345]
stop on runlevel [016]

respawn

exec /sbin/getty -L 115200 ttyS0 vt102
EOF

# apt sources
# uncomment the "deb" lines (no need to uncomment "deb src" lines)
perl -pi -e 's/^#+\s+(deb\s+http)/$1/g' /etc/apt/sources.list

# install software packages required
apt-get update
apt-get -y install ssh gdbserver nano apache2 php5 libapache2-mod-php5 openssh-client openssh-server python-dev ipython python-matplotlib python-numpy python-scipy

# create user "lcav" with password "1234"
username="lcav"
password="1234"
# encrypted password (needed for useradd)
encrypted_password="$(perl -e 'printf("%s\n", crypt($ARGV[0], "password"))' "${password}")"
useradd -m -p "${encrypted_password}" -s /bin/bash "${username}"

# ubuntu requires the admin to be part of the "adm" and "sudo" groups
addgroup ${username} adm
addgroup ${username} sudo

# set root password to "1234" (needed so we have a password to supply ARM DS-5
# when remote debugging)
echo -e "${password}\n${password}\n" | passwd root

# allow root SSH login with password (needed so we can use ARM DS-5 for remote
# debugging)
perl -pi -e 's/^(PermitRootLogin) without-password$/$1 yes/g' /etc/ssh/sshd_config

## add THIS computer's (LCAV X230) SSH key to the target board. On another computer, you will have to modify this key accordingly!
mkdir -p "/root/.ssh"
echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1s+gTiOeJcSx41KvRMfPKVwXuCvtrzZeBnp+bl3bhvWF4XVH6SX/ZIG9QdQ/WaZVnGHK2POleCXVxU4ydmzYjGLnJeaPMN5Q1kYHQm2z4i6zxNR9YS5kQJ9SECSzOtyQgHMLH/lvbH1rVGsjk97sIG04lzvNoXyauAr2EgPBU5hhk+/pLK069dJqF/TWnduSTsOxSU1XWSCfGpiKztFKeBKIIsWjrlS68Pa3xdc/WIp8zEXcf7rGQ/zJMselscVmJYoVg6Juvw+zlh+lu3geBwdltzvDeltZQM1Z7FtRJIbPInt07bljwWCBE3h+yC5rWPXBXCS0h8l4nQpM863zZ lcav@lcav-ThinkPad-X230" > "/root/.ssh/authorized_keys"
