# pbs-docker
Proxmox Backup Server in Docker

## Why this Dockerfile ?
I need to run PBS on my synology without bottleneck of NFS mount, etc.

This Dockerfile build a Proxmox Backup Server image.

It is used on my production environnement.

## Defaults volumes

### /etc/proxmox-backup
Contains PBS backup

### /backups
Backup repository

## Env variables

### MSMTP_HOST
Host for relay SMTP
### MSMTP_PORT
SMTP of relay SMTP host
### MSMTP_TLS
Host SMTP is TLS ? (on, off)
### MSMTP_STARTTLS
Host SMTP is STARTTLS (on, off)
### MSMTP_TLSCHECK
Check host SMTP cert
### MSMTP_AUTH
Host SMTP need authentication
### MSMTP_USER
Host SMTP username
### MSMTP_PASSWORD
Host SMTP password
### MSMTP_FROM
Host SMTP From
### PBS_ADMIN_PASSWORD
PBS default password (change it after boot the container), 5 chars minimum, if less, then crash
