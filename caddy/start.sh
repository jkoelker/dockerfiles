#!/bin/sh

echo "https://${RELAY_FQDN}:9001 {" > /etc/Caddyfile
echo "    proxy /weechat weechat:9001 {" >> /etc/Caddyfile
echo "        websocket" >> /etc/Caddyfile
echo "        timeout 0" >> /etc/Caddyfile
echo "    }" >> /etc/Caddyfile
echo "    tls {" >> /etc/Caddyfile
echo "        dns namecheap" >> /etc/Caddyfile
echo "    }" >> /etc/Caddyfile
echo "}" >> /etc/Caddyfile

exec /bin/parent /usr/bin/caddy \
    --conf /etc/Caddyfile \
    --email "${ACME_EMAIL}" \
    --log stdout \
    --agree="${ACME_AGREE}" "$@"
