#
FROM golang:1.13-alpine

ARG version="1.0.4"
ARG plugins="github.com/caddyserver/dnsproviders/namecheap"
ARG telemetry="false"

WORKDIR /build

COPY plugger.go ./

# build & test
RUN apk add --no-cache git ca-certificates \
    && printf "module caddy\\nrequire github.com/caddyserver/caddy v%s" "${version}" > go.mod \
    && go run plugger.go -plugins="${plugins}" -telemetry="${telemetry}" \
    && CGO_ENABLED=0 GOOS=linux GO111MODULE=on go build \
    && ./caddy -version \
	&& mv ./caddy /usr/bin

ENV RELAY_FQDN=''
ENV ACME_EMAIL=''
ENV ACME_AGREE=false

COPY start.sh /
RUN chmod +x /start.sh

EXPOSE 9001

ENTRYPOINT ["/start.sh"]
