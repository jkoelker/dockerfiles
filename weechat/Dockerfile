FROM debian:buster-slim

ENV TERM=screen-256color
ENV LANG=C.UTF-8
ENV UID=1000
ENV GID=1000

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY run.sh /

RUN groupadd \
		--gid "$GID" \
		weechat \
	&& useradd \
		--gid "$GID" \
		--home-dir /weechat \
		--shell /sbin/nologin \
		--uid "$UID" \
		weechat

# hadolint ignore=SC2086
RUN BUILD_DEPS="\
        autoconf \
        automake \
        build-essential \
        bzip2 \
        cmake \
        cpp \
        devscripts \
        debhelper \
        libgcrypt20-dev \
        libcurl4-gnutls-dev \
        libgnutls28-dev \
        libncurses-dev \
        libperl-dev \
        pkg-config \
        python-dev \
        rake \
        ruby \
        ruby-dev \
        zlib1g-dev \
        " \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        $BUILD_DEPS \
        ca-certificates \
        dirmngr \
        gpg \
        gpg-agent \
        jq \
        wget \
        xz-utils \
    && WEECHAT_VERSION="$(wget -O - https://api.github.com/repos/weechat/weechat/releases/latest | jq .tag_name -r | sed 's/^v//')" \
    && wget "https://weechat.org/files/src/weechat-${WEECHAT_VERSION}.tar.xz" -O /tmp/weechat.tar.xz \
    && mkdir -p /tmp/src/build \
    && tar -xf /tmp/weechat.tar.xz -C /tmp/src --strip-components 1 \
    && rm /tmp/weechat.tar.xz \
    && cmake -DENABLE_GUILE=OFF -DENABLE_PHP=OFF -S /tmp/src -B /tmp/src/build \
    && make -C /tmp/src/build -j "$(nproc)" \
    && make -C /tmp/src/build install \
    && rm -rf /tmp/src \
    && apt-get purge -y --auto-remove $BUILD_DEPS \
    && apt-get install -y --no-install-recommends \
        libgcrypt20 \
        libcurl3-gnutls \
        libdatetime-perl \
        libglib2.0-0 \
        libruby \
        libpython2.7 \
        libtcl8.6 \
        libgnutls30 \
        libncurses6 \
        libwww-perl \
        perl \
        python-setuptools \
        python-pip \
        zlib1g \
    && pip install websocket-client

VOLUME /weechat
WORKDIR /weechat

EXPOSE 9001

ENTRYPOINT ["/run.sh"]
CMD ["--dir /weechat"]
