FROM abiosoft/caddy:builder as builder

ARG version="0.11.2"
ARG plugins="namecheap"

# process wrapper
RUN go get -v github.com/abiosoft/parent

RUN VERSION=${version} \
    PLUGINS=${plugins} \
    ENABLE_TELEMETRY=false \
    /bin/sh /usr/bin/builder.sh

FROM alpine:3.8

ENV RELAY_FQDN=''
ENV ACME_EMAIL=''
ENV ACME_AGREE=false

# Telemetry Stats
ENV ENABLE_TELEMETRY="false"

RUN apk add --no-cache ca-certificates

# install caddy
COPY --from=builder /install/caddy /usr/bin/caddy

# install process wrapper
COPY --from=builder /go/bin/parent /bin/parent

COPY start.sh /
RUN chmod +x /start.sh

EXPOSE 9001

ENTRYPOINT ["/start.sh"]
