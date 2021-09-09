# SPDX-FileCopyrightText: 2021 Xiaodong Xu <xuxiaodong@pm.me>
#
# SPDX-License-Identifier: MIT

FROM debian:bookworm-slim

LABEL org.opencontainers.image.authors="xuxiaodong@pm.me"

ARG ARCH=arm64
ARG MICROARCH=aarch64
ARG SUFFIX=gnu

# hadolint ignore=DL3008
RUN dpkg --add-architecture ${ARCH} \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    crossbuild-essential-${ARCH} \
    autoconf \
    automake \
    bison \
    cmake \
    flex \
    m4 \
    meson \
    ninja-build \
    qemu-user \
    && apt-get clean \
    && rm -rv /var/lib/apt/lists/*

ENV CROSS_TRIPLE ${MICROARCH}-linux-${SUFFIX}
ENV CROSS_ROOT /usr/bin
ENV AS=${CROSS_ROOT}/${CROSS_TRIPLE}-as \
    AR=${CROSS_ROOT}/${CROSS_TRIPLE}-ar \
    CC=${CROSS_ROOT}/${CROSS_TRIPLE}-gcc \
    CPP=${CROSS_ROOT}/${CROSS_TRIPLE}-cpp \
    CXX=${CROSS_ROOT}/${CROSS_TRIPLE}-g++ \
    LD=${CROSS_ROOT}/${CROSS_TRIPLE}-ld

ENV QEMU_LD_PREFIX /usr/${CROSS_TRIPLE}
ENV QEMU_SET_ENV "LD_LIBRARY_PATH=/usr/${CROSS_TRIPLE}/lib:${QEMU_LD_PREFIX}"

ENV CROSS_COMPILE ${CROSS_TRIPLE}-
ENV ARCH ${MICROARCH}
