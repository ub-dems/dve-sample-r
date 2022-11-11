#!/bin/bash

## Set defaults for environmental variables in case they are undefined
DEFAULT_USER=${DEFAULT_USER:-rstudio}
USER=${USER:=${DEFAULT_USER}}
USERID=${USERID:=1000}
GROUPID=${GROUPID:=1000}
ROOT=${ROOT:=TRUE}
UMASK=${UMASK:=002}
LANG=${LANG:=en_US.UTF-8}
TZ=${TZ:=Etc/UTC}

bold=$(tput bold)
normal=$(tput sgr0)

##
# set root equivalence
#

#usermod  -o --uid 0 --gid 0  rstudio-server
#groupmod -o         --gid 0  rstudio-server

#usermod  -o --uid 0 --gid 0  $USER
#groupmod -o         --gid 0  $USER

##
# avoid /etc/bash.bashrc message

touch /root/.sudo_as_admin_successful

##
# launch with: 
# 
# podman run --rm --ulimit=host -p 8787:8787 -e PASSWORD=Sec3et -v ~/work:/root/work:Z  -e USER=root -e USERID=0 -e GROUPID=0 -e ROOT=true  "image-name"
#

sed -i '/auth-minimum-user-id/d'      /etc/rstudio/rserver.conf
echo    'auth-minimum-user-id = 0' >> /etc/rstudio/rserver.conf


sed -i '/auth-minimum-user-id/d'      /etc/rstudio/disable_auth_rserver.conf
echo    'auth-minimum-user-id = 0' >> /etc/rstudio/disable_auth_rserver.conf


sed -i 's/"$USER" != "$DEFAULT_USER"/ "$USER" != "$DEFAULT_USER" -a "$USER" != "root"/g'      \
                                      /etc/cont-init.d/02_userconf

##
# add 'dsdata' access group
#
groupadd --gid 840 dsdata
useradd -r -m -d /var/lib/dsdata -u 840 -g dsdata -s/bin/bash dsdata
passwd -l dsdata
chmod 750 /var/lib/dsdata

usermod  -a -G dsdata root

##
# enable 'info' logging
#
cat > /etc/rstudio/logging.conf <<EOF

[*]
log-level=info
logger-type=syslog

[@rserver]
log-level=debug
logger-type=file
max-size-mb=10

[file-locking]
log-dir=/var/log/file-locking
log-file-mode=600

EOF
