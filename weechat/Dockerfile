FROM debian:bullseye-slim

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
        libaspell-dev \
        libgcrypt20-dev \
        libcurl4-gnutls-dev \
        libgnutls28-dev \
        libncurses-dev \
        libperl-dev \
        pkg-config \
        python3-dev \
        rake \
        ruby \
        ruby-dev \
        zlib1g-dev \
        " \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        $BUILD_DEPS \
        aspell \
        aspell-en \
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
    && cmake -DENABLE_GUILE=OFF -DENABLE_PHP=OFF -DENABLE_JAVASCRIPT=OFF -DENABLE_TCL=OFF -DENABLE_LUA=OFF -S /tmp/src -B /tmp/src/build \
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
        libpython3.8 \
        libtcl8.6 \
        libgnutls30 \
        libncurses6 \
        libwww-perl \
        perl \
        python3-setuptools \
        python3-pip \
        zlib1g \
    && pip3 install websocket-client

VOLUME /weechat
WORKDIR /weechat

EXPOSE 9001

ENTRYPOINT ["/run.sh"]
CMD ["--dir /weechat"]
