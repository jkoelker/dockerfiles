FROM docker.io/python:2-alpine

RUN mkdir /root/bin /root/.local

# From https://github.com/crazy-max/docker-rtorrent-rutorrent/

ENV RTORRENT_VERSION=0.9.7 \
  LIBTORRENT_VERSION=0.13.7 \
  XMLRPC_VERSION=01.53.00 \
  LIBSIG_VERSION=2.10.0 \
  CARES_VERSION=1.14.0 \
  CURL_VERSION=7.60.0 \
  PYRO_CONFIG_DIR=/config/.pyroscope \
  PATH="/usr/local/pyroscope/bin:${PATH}"

RUN apk --update --no-cache add -t build-dependencies \
    build-base \
    git \
    findutils \
    libtool \
    linux-headers \
    tini \
    automake \
    autoconf \
    subversion \
    tar \
    wget \
    xz \
    binutils \
    cppunit-dev \
    libressl-dev \
    ncurses-dev \
    zlib-dev \
  && cd /tmp \
  && svn checkout http://svn.code.sf.net/p/xmlrpc-c/code/release_number/${XMLRPC_VERSION}/ xmlrpc-c \
  && cd xmlrpc-c && ./configure && make -j$(nproc) && make install \
  && cd /tmp && wget http://ftp.gnome.org/pub/GNOME/sources/libsigc++/2.10/libsigc++-${LIBSIG_VERSION}.tar.xz \
  && unxz libsigc++-${LIBSIG_VERSION}.tar.xz && tar -xf libsigc++-${LIBSIG_VERSION}.tar \
  && cd libsigc++-${LIBSIG_VERSION} && ./configure && make -j$(nproc) && make install \
  && cd /tmp && wget https://c-ares.haxx.se/download/c-ares-${CARES_VERSION}.tar.gz \
  && tar zxf c-ares-${CARES_VERSION}.tar.gz \
  && cd c-ares-${CARES_VERSION} && ./configure && make -j$(nproc) && make install \
  && cd /tmp && wget https://curl.haxx.se/download/curl-${CURL_VERSION}.tar.gz \
  && tar zxf curl-${CURL_VERSION}.tar.gz \
  && cd curl-${CURL_VERSION}  && ./configure --enable-ares --enable-tls-srp --enable-gnu-tls --with-ssl --with-zlib && make -j$(nproc) && make install \
  && cd /tmp && git clone https://github.com/rakshasa/libtorrent.git && cd libtorrent && git checkout tags/v${LIBTORRENT_VERSION} \
  && ./autogen.sh && ./configure --with-posix-fallocate && make -j$(nproc) && make install \
  && cd /tmp && git clone https://github.com/rakshasa/rtorrent.git && cd rtorrent && git checkout tags/v${RTORRENT_VERSION} \
  && ./autogen.sh && ./configure --with-xmlrpc-c --with-ncurses && make -j$(nproc) && make install \
  && cd /tmp && rm -rf * \
  && apk del build-dependencies \
  && rm -rf /var/cache/apk/*

RUN apk --update --no-cache add \
    bash binutils coreutils grep shadow supervisor tzdata util-linux zlib \
    findutils ca-certificates bind-tools dhclient libressl libstdc++ ncurses \
    git curl gzip mediainfo sox tar unrar unzip wget zip \
  && mkdir -p /var/log/supervisord \
  && rm -rf /var/cache/apk/*

RUN git clone https://github.com/pyroscope/pyrocore.git /usr/local/pyrocore \
  && pip install -e "/usr/local/pyrocore[templating,repl]"

ENTRYPOINT ["rtorrent"]
CMD ["-n", "-o", "system.daemon.set=true", "-o", "try_import=/config/rtorrent.rc"]
