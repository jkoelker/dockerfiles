ARG FROM_TAG=latest
FROM debian:${FROM_TAG}

ENV TOOLCHAIN_DIR=/espressif
ENV PATH="${TOOLCHAIN_DIR}/bin:${PATH}"
ENV IDF_PATH=/esp32/esp-idf

RUN apt-get update \
 && apt-get install --no-install-recommends --yes \
    bison \
    flex \
    gcc \
    git \
    gperf \
    libncurses-dev \
    make \
    python \
    python-cryptography \
    python-future \
    python-pip \
    python-pyparsing \
    python-serial \
    python-setuptools \
    python-wheel \
    wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ARG TOOLCHAIN_URI=https://dl.espressif.com/dl/xtensa-esp32-elf-linux64-1.22.0-80-g6c4433a-5.2.0.tar.gz
RUN mkdir -p "${TOOLCHAIN_DIR}" \
 && wget -O "${TOOLCHAIN_DIR}/toolchain.tar.gz" "${TOOLCHAIN_URI}" \
 && tar xzvf \
        "${TOOLCHAIN_DIR}/toolchain.tar.gz" \
        -C "${TOOLCHAIN_DIR}" \
        --strip-components=1 \
 && rm -f "${TOOLCHAIN_DIR}/toolchain.tar.gz"

ARG IDF_VERSION=master
RUN mkdir -p "${IDF_PATH}" \
 && git -c advice.detachedHead=false \
        clone --recursive --depth 1 --branch "${IDF_VERSION}" \
        https://github.com/espressif/esp-idf.git "${IDF_PATH}" \
 && pip install -r "${IDF_PATH}/requirements.txt"
