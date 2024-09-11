ARG PACKAGE_NAME=obs-backgroundremoval
ARG PACKAGE_VERSION=1.1.13

ENV CPU_ARCH=x86_64
ENV DEBIAN_FRONTEND=noninteractive


FROM debian:bookworm

RUN set -eux \
 && apt-get --yes update \
 && apt-get --yes install --no-install-recommends \
        build-essential \
        ca-certificates \
        cmake \
        curl \
        libcurl4-openssl-dev \
        git \
        libobs-dev \
        libonnx-dev \
        libopencv-dev \
        libsimde-dev \
        wget \
 && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/locaal-ai/obs-backgroundremoval.git \
 && cd obs-backgroundremoval \
 && git checkout ${PACKAGE_VERSION} \
 && mkdir build \
 && cd build \
 && cmake .. \
 && cmake --build . \
 && cmake --install . \
 && mkdir --parents /build

VOLUME [ "/build" ]

CMD set -eux \
 && mkdir --parents /build/usr/lib/${CPU_ARCH}-linux-gnu/obs-plugins/ \
 && cp --force /usr/local/lib/obs-plugins/obs-backgroundremoval.so /build/usr/lib/${CPU_ARCH}-linux-gnu/obs-plugins/ \
 && cp --force /usr/local/lib/obs-plugins/obs-backgroundremoval/libonnxruntime.so* /build/usr/lib/${CPU_ARCH}-linux-gnu/ \
 && mkdir --parents /build/usr/share/obs/obs-plugins/obs-backgroundremoval/ \
 && cp --force --recursive /usr/local/share/obs/obs-plugins/obs-backgroundremoval/* /build/usr/share/obs/obs-plugins/obs-backgroundremoval/
