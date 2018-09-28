FROM docker.io/alpine:3.8

RUN apk add --no-cache bash rtorrent tini

ENTRYPOINT ["/sbin/tini", "--", "rtorrent"]
CMD ["-n", "-o", "system.daemon.set=true", "-o", "try_import=/config/rtorrent.rc"]
