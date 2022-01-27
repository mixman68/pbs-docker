FROM debian:bullseye-slim

ADD http://download.proxmox.com/debian/proxmox-release-bullseye.gpg /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg

#add key and apt install etc
RUN apt-get update \
    && apt install -y ifupdown2 \
    && chmod 644 /etc/apt/trusted.gpg.d/proxmox-release-bullseye.gpg && echo "deb http://download.proxmox.com/debian/pbs bullseye pbs-no-subscription" > /etc/apt/sources.list.d/proxmox.list \
    && mkdir -p /var/lib/dhcp/ \
    && apt-get update \
    && apt-get install -y proxmox-backup-server=2.1.3-1 nfs-common supervisor msmtp-mta gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY msmtprc /etc/msmtprc
COPY pbs.ini /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh && chsh -s /bin/bash backup



ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
VOLUME [ "/etc/proxmox-backup", "/backups" ]
STOPSIGNAL SIGINT