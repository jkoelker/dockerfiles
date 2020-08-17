FROM alpine:3 as builder

RUN apk add --no-cache \
        alpine-sdk \
        autoconf \
        automake \
        libtool \
        ncurses-dev \
        openssl-dev \
        perl \
        perl-dev \
        perl-doc \
        perl-io-tty \
        protobuf-dev \
        tmux \
        zlib-dev \
    && git clone -b foreground --depth 1 \
        https://github.com/jkoelker/mosh.git /mosh

WORKDIR /mosh
RUN ./autogen.sh && ./configure && make \
        && strip /mosh/src/frontend/mosh-server

FROM alpine:3

RUN apk add --no-cache \
        docker-cli \
        mosh-server

COPY --from=builder /mosh/src/frontend/mosh-server /usr/bin/mosh-server

ENTRYPOINT ["mosh-server"]
