#!/bin/bash -x

# locale
localedef -i en_US -c -f UTF-8 en_US.UTF-8
dpkg-reconfigure locales

# timezone
echo "Europe/Zurich" > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata


## Network stack configuration

# Install the base packages

dpkg -i /iproute2.deb
dpkg -i /dhcpcd5.deb

# Configure the network interfaces
cat <<EOF > /etc/network/interfaces
# interfaces(5) file used by ifup(8) and ifdown(8)

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
auto eth0
iface eth0 inet dhcp
EOF

cat <<EOF >> /etc/dhcpcd.conf
timeout 20;
lease {
  interface "eth0";
  fixed-address 10.42.0.2;
  option subnet-mask 255.255.255.0;
  renew 2 2022/1/1 00:00:01;
  rebind 2 2022/1/1 00:00:01;
  expire 2 2022/1/1 00:00:01;
}
EOF
# Start the DHCP service

systemctl enable dhcpcd
systemctl start dhcpcd

# Enable the network interface
ip link set dev eth0 up

dhcpcd eth0

# Now the network should be up
apt-get update
apt-get install avahi-daemon avahi-discover avahi-utils avahi-dnsconfd libnss-mdns mdns-scan samba

# Configure the services to have the hostname bound to MDNS / Avahi (pyramic.local), NetBIOS (Windows)
echo "pyramic" > /etc/hostname

cat <<EOF > /etc/hosts
127.0.0.1   localhost
127.0.1.1   pyramic
EOF

cat <<EOF > /etc/samba/smb.conf
workgroup = WORKGROUP
netbios name = pyramic
EOF



systemctl enable avahi-daemon
systemctl enable smbd
systemctl enable nmbd
ln -sf /usr/lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@ttyS0.service


# enable serial console for login shell
# cat <<EOF > /etc/init/ttyS0.conf
# # ttyS0 - getty
# #
# # This service maintains a getty on ttyS0
# 
# description "Get a getty on ttyS0"
# 
# start on runlevel [2345]
# stop on runlevel [016]
# 
# respawn
# 
# exec /sbin/getty -L 115200 ttyS0 vt102
# EOF

# apt sources
# uncomment the "deb" lines (no need to uncomment "deb src" lines)
perl -pi -e 's/^#+\s+(deb\s+http)/$1/g' /etc/apt/sources.list

# install software packages required

apt-get -y install ssh gdbserver nano openssh-client openssh-server python-dev ipython python-matplotlib python-numpy python-scipy

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

# ## add THIS computer's (LCAV X230) SSH key to the target board. On another computer, you will have to modify this key accordingly!
# mkdir -p "/root/.ssh"
# echo "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC1s+gTiOeJcSx41KvRMfPKVwXuCvtrzZeBnp+bl3bhvWF4XVH6SX/ZIG9QdQ/WaZVnGHK2POleCXVxU4ydmzYjGLnJeaPMN5Q1kYHQm2z4i6zxNR9YS5kQJ9SECSzOtyQgHMLH/lvbH1rVGsjk97sIG04lzvNoXyauAr2EgPBU5hhk+/pLK069dJqF/TWnduSTsOxSU1XWSCfGpiKztFKeBKIIsWjrlS68Pa3xdc/WIp8zEXcf7rGQ/zJMselscVmJYoVg6Juvw+zlh+lu3geBwdltzvDeltZQM1Z7FtRJIbPInt07bljwWCBE3h+yC5rWPXBXCS0h8l4nQpM863zZ lcav@lcav-ThinkPad-X230" > "/root/.ssh/authorized_keys"

# Disable ourselves

cat <<EOF > "/etc/rc.local"
#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

exit 0
EOF
