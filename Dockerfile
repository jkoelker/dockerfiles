FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y wget

ADD btsync.sh /btsync.sh
ADD sync.conf /default_sync.conf

RUN wget -O - http://download-lb.utorrent.com/endpoint/btsync/os/linux-x64/track/stable | tar xzf - -C / btsync

EXPOSE 8889
EXPOSE 8889/udp
EXPOSE 8888

ENTRYPOINT ["/btsync.sh"]
CMD ["--config", "/sync/sync.conf", "--nodaemon"]
