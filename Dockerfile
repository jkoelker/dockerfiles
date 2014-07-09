FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y nodejs \
                       npm \
                       wget

RUN wget -O - https://github.com/seanmheff/PiTorrent/archive/master.tar.gz | tar xz -C / --xform="s/PiTorrent-master/pitorrent/"
ADD config.json /pitorrent/config/config.json

WORKDIR /pitorrent
RUN npm install /pitorrent

ENV NODE_ENV production
EXPOSE 3000
ENTRYPOINT ["/usr/bin/nodejs"]
CMD ["/pitorrent/app.js"]
