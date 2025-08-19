FROM debian:trixie

ARG PBS_VERSION=4.0.14-1
ADD --chmod="0644" https://enterprise.proxmox.com/debian/proxmox-archive-keyring-trixie.gpg /usr/share/keyrings/proxmox-archive-keyring.gpg

ADD proxmox.sources /etc/apt/sources.list.d/proxmox.sources

#add key and apt install etc
RUN apt-get update \
    && apt-get install -y ifupdown2 rsyslog \
    && mkdir -p /var/lib/dhcp/ \
    && apt-get update \
    && apt-get install -y proxmox-backup-server=${PBS_VERSION} proxmox-backup-client=${PBS_VERSION} nfs-common supervisor msmtp-mta gettext-base \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY msmtprc /etc/msmtprc
COPY pbs.ini /etc/supervisor/conf.d/supervisord.conf
COPY rsyslog.conf /etc/rsyslog.conf
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh && chsh -s /bin/bash backup



ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
VOLUME [ "/etc/proxmox-backup", "/backups", "/var/lib/proxmox-backup", "/var/log/proxmox-backup" ]
STOPSIGNAL SIGINT
