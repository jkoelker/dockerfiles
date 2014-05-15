FROM debian:jessie

RUN DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y netmask isc-dhcp-server

ADD dhcpd.sh /dhcpd
ADD dhcpd.conf /default_dhcpd.conf

EXPOSE 67
EXPOSE 67/udp
EXPOSE 547
EXPOSE 547/udp
EXPOSE 647
EXPOSE 647/udp
EXPOSE 847
EXPOSE 847/udp

ENTRYPOINT ["/dhcpd"]
CMD ["-f", "-cf", "/data/dhcpd.conf", "-lf", "/data/dhcpd.leases", "--no-pid"]
