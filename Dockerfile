FROM debian:buster

ADD http://download.proxmox.com/debian/proxmox-ve-release-6.x.gpg /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg

#add key and apt install etc
RUN chmod 644 /etc/apt/trusted.gpg.d/proxmox-ve-release-6.x.gpg && echo "deb http://download.proxmox.com/debian/pbs buster pbs-no-subscription" > /etc/apt/sources.list.d/proxmox.list \
    && apt-get update && apt-get install -y proxmox-backup-server=1.0.1-1 nfs-common supervisor \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY pbs.ini /etc/supervisor/conf.d/supervisord.conf
COPY docker-entrypoint.sh /
RUN chmod a+x /docker-entrypoint.sh && chsh -s /bin/bash backup



ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["/usr/bin/supervisord"]
VOLUME [ "/etc/proxmox-backup", "/backups" ]
STOPSIGNAL SIGINT