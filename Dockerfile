# SPDX-FileCopyrightText: 2023 Joel Rangsmo <joel@rangsmo.se>
# SPDX-License-Identifier: CC0-1.0
FROM debian:bookworm-slim

# Setup unprivileged user and input/output directories
RUN mkdir /input /output \
		&& useradd --home-dir /tmp --shell /bin/bash app \
		&& chown app:app /input /output

# Install container build and runtime dependencies
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	ca-certificates chromium coreutils curl moreutils poppler-utils qrencode xauth xvfb zip \
	&& rm -rf /var/lib/apt-get/lists/* \
	&& apt-get autoremove -y

# Download, validate and install Drawio artifact
ARG DRAWIO_URL=https://github.com/jgraph/drawio-desktop/releases/download/v22.0.3/drawio-amd64-22.0.3.deb
ARG DRAWIO_CHECKSUM=3e1a98c4ca64694393a9ba0406104e50418cd0dd6fef193a6f093ad267abadde
WORKDIR /tmp
RUN curl --location --output drawio.deb $DRAWIO_URL \
		&& echo "$DRAWIO_CHECKSUM drawio.deb" > SHA256SUMS \
		&& sha256sum --check SHA256SUMS \
		&& apt-get install -y --no-install-recommends ./drawio.deb \
		&& rm -rf /var/lib/apt-get/lists/* \
		&& apt-get autoremove -y \
		&& rm -rf drawio.deb SHA256SUMS

# Download, validate and install Marp CLI artifact
ARG MARP_URL=https://github.com/marp-team/marp-cli/releases/download/v3.4.0/marp-cli-v3.4.0-linux.tar.gz
ARG MARP_CHECKSUM=dbf95eb2c708913a59be9e1f01bde135e0851a7d8ef7b0034aa9ffe74389012b
WORKDIR /tmp
RUN curl --location --output marp.tar.gz $MARP_URL \
		&& echo "$MARP_CHECKSUM marp.tar.gz" > SHA256SUMS \
		&& sha256sum --check SHA256SUMS \
		&& tar xvf marp.tar.gz \
		&& install --mode 755 marp /usr/local/bin \
		&& rm -rf marp.tar.gz SHA256SUMS marp 

# Install script
COPY scenskrack /usr/local/bin/

USER app
WORKDIR /input
ENTRYPOINT ["scenskrack", "-i", "/input", "-o", "/output"]
