FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y rtorrent

ENTRYPOINT ["/usr/bin/rtorrent"]
CMD ["-n", "-o", "try_import=/config/rtorrent.rc"]
