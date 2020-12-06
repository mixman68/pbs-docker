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

exec "$@"