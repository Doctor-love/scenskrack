# SPDX-FileCopyrightText: 2022 Joel Rangsmo <joel@rangsmo.se>
# SPDX-License-Identifier: GPL-2.0-or-later
FROM debian:bullseye-slim

# Arguments/Variables for artifacts
ARG DRAWIO_URL=https://github.com/jgraph/drawio-desktop/releases/download/v20.6.2/drawio-amd64-20.6.2.deb
ARG DRAWIO_CHECKSUM=08d6b868d6fb2c1d3187e28498285058b0a59398dbff31cf4c26f2955abe734a
ARG MARP_URL=https://github.com/marp-team/marp-cli/releases/download/v2.2.2/marp-cli-v2.2.2-linux.tar.gz
ARG MARP_CHECKSUM=4ae79f62bdad1e74263687be1211906a437c1e84994f96fcf4640809af53448c

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
