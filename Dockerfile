# SPDX-FileCopyrightText: 2023 Joel Rangsmo <joel@rangsmo.se>
# SPDX-License-Identifier: CC0-1.0
FROM debian:bullseye-slim

# Arguments/Variables for artifacts
ARG DRAWIO_URL=https://github.com/jgraph/drawio-desktop/releases/download/v21.2.1/drawio-amd64-21.2.1.deb
ARG DRAWIO_CHECKSUM=66ee32baace526728c4ea4c949daa29bfc5a260bf78ed9436401dc84983b9ffb
ARG MARP_URL=https://github.com/marp-team/marp-cli/releases/download/v2.5.0/marp-cli-v2.5.0-linux.tar.gz
ARG MARP_CHECKSUM=bdcfa88e44aec6d77b5cd5b95b3b21f203081334c782e2d5b69d484b72c89667

# Install container build and runtime dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates chromium coreutils curl moreutils poppler-utils qrencode xauth xvfb zip \
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
RUN useradd --home-dir /tmp --shell /bin/bash app
RUN chown app:app /input /output

# Install and configure script execution
COPY scenskrack /usr/local/bin/

USER app
WORKDIR /input
ENTRYPOINT ["scenskrack", "-i", "/input", "-o", "/output"]
