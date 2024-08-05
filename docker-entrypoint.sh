#!/bin/bash
set -e

#User mapping
if [ -z $PUID ]; then export PUID=34; fi
if [ -z $PGID ]; then export PGID=34; fi
groupmod -o -g "$PGID" backup
usermod -o -u "$PUID" backup

#Fix perm
mkdir -p /etc/proxmox-backup
if [ -z $PBS_FIXPERM ]; then 
    echo "Skip fix perm"
else
    echo "Fix perm"
    chown -R backup:backup /etc/proxmox-backup
    chown -R backup:backup /var/lib/proxmox-backup
    chown -R backup:backup /var/log/proxmox-backup
    chown -R backup:backup /backups
    chmod -R 700 /etc/proxmox-backup
fi

if [ -z $PBS_ADMIN_PASSWORD ]; then export PBS_ADMIN_PASSWORD=admin; fi

#Add a user
if [ ! -f /etc/proxmox-backup/user.cfg ]; then
    proxmox-backup-manager user create admin@pbs --password $PBS_ADMIN_PASSWORD 
    proxmox-backup-manager acl update / Admin --auth-id admin@pbs

    chown -R backup:backup /etc/proxmox-backup
fi

#Build MSMTPRC File
if [ -z $MSMTP_HOST ]; then export MSMTP_HOST=localhost; fi
if [ -z $MSMTP_PORT ]; then export MSMTP_PORT=25; fi
if [ -z $MSMTP_TLS ]; then export MSMTP_TLS=off; fi
if [ -z $MSMTP_STARTTLS ]; then export MSMTP_STARTTLS=off; fi
if [ -z $MSMTP_TLSCHECK ]; then export MSMTP_TLSCHECK=off; fi
if [ -z $MSMTP_AUTH ]; then export MSMTP_AUTH=; fi
if [ -z $MSMTP_USER ]; then export MSMTP_USER=; fi
if [ -z $MSMTP_PASSWORD ]; then export MSMTP_PASSWORD=; fi
if [ -z $MSMTP_FROM ]; then export MSMTP_FROM=root@localhost; fi
cp /etc/msmtprc /tmp/msmtprc.env
envsubst < /tmp/msmtprc.env > /etc/msmtprc

#Subst PUID/GID in supervisord
cp /etc/supervisor/conf.d/supervisord.conf /tmp/supervisord.conf
envsubst < /tmp/supervisord.conf > /etc/supervisor/conf.d/supervisord.conf

# Remove lock files if present
rm -f /etc/proxmox-backup/*.lock /etc/proxmox-backup/.*.lck

exec "$@"