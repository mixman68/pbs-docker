#!/bin/bash
set -e

#Fix perm (34 is backup)
chown -R 34:34 /etc/proxmox-backup
chmod -R 700 /etc/proxmox-backup

#Add a user
if [ ! -f /etc/proxmox-backup/user.cfg ]; then
    proxmox-backup-manager user create admin@pbs --password admin 
    proxmox-backup-manager acl update / Admin --auth-id admin@pbs
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

exec "$@"