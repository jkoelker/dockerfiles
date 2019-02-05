FROM docker/compose:1.23.2

COPY . /rootfs/compose
WORKDIR /rootfs/compose

CMD ["up", "--build"]
