FROM crosbymichael/python

RUN echo "deb http://http.debian.net/debian jessie non-free" > /etc/apt/sources.list.d/non-free.list

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y python-cheetah \
                       unrar \
                       wget

ADD sickrage.sh /sickrage.sh
RUN wget -O - https://github.com/echel0n/SickRage/archive/master.tar.gz | tar xz -C / --xform="s/SickRage-master/sickrage/"

EXPOSE 8081

ENTRYPOINT ["/sickrage.sh"]
CMD ["--nolaunch", "--config=/config/config.ini", "--datadir=/data"]
