FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y deluge-web

ADD deluge-web.sh /deluge-web

EXPOSE 8080

ENTRYPOINT ["/deluge-web"]
CMD ["-c", "/config", "-p", "8080"]
