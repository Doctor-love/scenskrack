# SPDX-FileCopyrightText: 2022 Joel Rangsmo <joel@rangsmo.se>
# SPDX-License-Identifier: GPL-2.0-or-later

# Debian 10 is used as the drawio deb file specifies dependency versions not available in Debian 11
FROM debian:buster-slim

# Arguments/Variables for artifacts
ARG DRAWIO_URL=https://github.com/jgraph/drawio-desktop/releases/download/v19.0.3/drawio-amd64-19.0.3.deb
ARG DRAWIO_CHECKSUM=9935516eac0f5e39ce0b2b6b1cf1419f662d06a1ff4ee712526b397786df9622
ARG MARP_URL=https://github.com/marp-team/marp-cli/releases/download/v2.0.4/marp-cli-v2.0.4-linux.tar.gz
ARG MARP_CHECKSUM=a18ee9243f103cb2983799e05648acd1af47db7f4d092393aca06e5f54e642ba

# Install container build and runtime dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates chromium coreutils curl poppler-utils qrencode xauth xvfb zip \
	&& rm -rf /var/lib/apt-get/lists/* \
	&& apt-get autoremove -y

# Download and validate artifacts
WORKDIR /tmp
RUN curl --location --output drawio.deb $DRAWIO_URL
RUN curl --location --output marp.tar.gz $MARP_URL
RUN /bin/echo -e "$DRAWIO_CHECKSUM drawio.deb\n$MARP_CHECKSUM marp.tar.gz" > SHA256SUMS
RUN sha256sum --check SHA256SUMS

# Install drawio desktop client and Marp CLI
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	./drawio.deb \
	&& rm -rf /var/lib/apt-get/lists/* \
	&& apt-get autoremove -y

RUN tar xvf marp.tar.gz
RUN install --mode 755 marp /usr/local/bin

# Cleanup artifacts
RUN rm -rf drawio.deb marp.tar.gz marp

# Setup unprivileged user and input/output directories
RUN mkdir /input /output
RUN useradd --home-dir /input --shell /bin/bash app
RUN chown app:app /input /output

# Install and configure script execution
COPY scenskrack /usr/local/bin/

USER app
WORKDIR /input
CMD ["scenskrack", "/input", "/output"]
