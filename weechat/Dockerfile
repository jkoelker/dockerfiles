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
    && wget -O /tmp/rustup-init https://static.rust-lang.org/rustup/dist/x86_64-unknown-linux-gnu/rustup-init \
	&& RUSTUP_HOME=$(mktemp -d) \
	&& CARGO_HOME=$(mktemp -d) \
	&& PATH="$CARGO_HOME/bin:$PATH" \
	&& export RUSTUP_HOME \
	&& export CARGO_HOME \
	&& export PATH \
    && chmod +x /tmp/rustup-init \
    && /tmp/rustup-init -y --no-modify-path \
    && rm -rf /tmp/rustup-init \
	&& mkdir /tmp/src \
	&& wget -O /tmp/discord.tar.gz https://github.com/terminal-discord/weechat-discord/archive/master.tar.gz \
    && tar -xf /tmp/discord.tar.gz -C /tmp/src --strip-components 1 \
    && cargo build --manifest-path /tmp/src/Cargo.toml --release \
    && cp /tmp/src/target/release/libweecord.so /usr/local/lib/weechat/plugins \
    && rm -rf /tmp/src "$RUSTUP_HOME" "$CARGO_HOME" \
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
