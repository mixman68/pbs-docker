FROM debian:bookworm

ARG PBS_VERSION=3.2.7-1

ADD http://download.proxmox.com/debian/proxmox-release-bookworm.gpg /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg

#add key and apt install etc
RUN apt-get update \
    && apt-get install -y ifupdown2 \
    && chmod 644 /etc/apt/trusted.gpg.d/proxmox-release-bookworm.gpg && echo "deb http://download.proxmox.com/debian/pbs bookworm pbs-no-subscription" > /etc/apt/sources.list.d/proxmox.list \
    && mkdir -p /var/lib/dhcp/ \
    && apt-get update \
    && apt-get install -y proxmox-backup-server=${PBS_VERSION} proxmox-backup-client=${PBS_VERSION} nfs-common supervisor msmtp-mta gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY msmtprc /etc/msmtprc
COPY pbs.ini /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh && chsh -s /bin/bash backup



ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
VOLUME [ "/etc/proxmox-backup", "/backups", "/var/lib/proxmox-backup", "/var/log/proxmox-backup" ]
STOPSIGNAL SIGINT
