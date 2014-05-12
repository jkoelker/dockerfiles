FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y deluged

ADD deluged.sh /deluged

EXPOSE 58846

ENTRYPOINT ["/deluged"]
CMD ["-c", "/config", "-d", "-p", "58846"]
