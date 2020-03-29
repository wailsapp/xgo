################################################################################
# xgo-wails is a multi-stage Dockerfile intended to build a Docker image
# capable of compiling for the following platforms:
#
# Linux
#   arm5: linux/arm, linux/arm-5 (broken)
#   arm6: linux/arm-6            (broken)
#   arm7: linux/arm-7
#
# Mac OS X (Darwin)
#   386:   darwin/386   (please don't use)
#   amd64: darwin/amd64
#
# Windows
#   386:    windows/i386
#   amd64:  windows/amd64
#
# Building the image:
#     docker build -t xgo-wails:develop Docker
#
# Can be run directly as follows:
#     xgo -v -image xgo-wails:develop -targets=linux/arm-7 ./
#
################################################################################
ARG XGO_IMAGE=crazymax/xgo
ARG XGO_VERSION=1.14.1

# Platform armhf | DO NOT combine with x86_64 or it breaks the apt-get install
FROM $XGO_IMAGE:$XGO_VERSION as armhf
COPY arm.list /etc/apt/sources.list.d
RUN apt-get update && \
  dpkg --add-architecture armhf && \
  apt-get install -y --no-install-recommends \
  libwebkit2gtk-4.0:armhf \
  libgtk-3-dev:armhf \
  libsoup2.4-dev:armhf \
  libgdk-pixbuf2.0-dev:armhf \
  libpango1.0-dev:armhf \
  libharfbuzz-dev:armhf \
  libxml2-dev:armhf \
  libicu-dev:armhf && \
  rm -rf /var/lib/apt/lists/*
# Platform armhf

FROM $XGO_IMAGE:$XGO_VERSION as x86_64

RUN \
  apt-get update && \
  apt-get --no-install-recommends install -y \
  libwebkit2gtk-4.0=* libgtk-3.0=* \
  libwebkit2gtk-4.0-dev:* \
  curl && \
  rm -rf /var/lib/apt/lists/* && \
  /usr/bin/curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.4/gosu-$(dpkg --print-architecture)" \
  && chmod +x /usr/local/bin/gosu

FROM $XGO_IMAGE:$XGO_VERSION

# Override the base image's build.sh file
# REMOVEME: Once PR gets merged to upstream
COPY build.sh /build.sh
RUN chmod +x /build.sh

# # x86_64
COPY --from=x86_64 /lib/x86_64-linux-gnu /lib/x86_64-linux-gnu
COPY --from=x86_64 /usr/lib/x86_64-linux-gnu /usr/lib/x86_64-linux-gnu
COPY --from=x86_64 /usr/include /usr/include
COPY --from=x86_64 /usr/share/pkgconfig /usr/share/pkgconfig
COPY --from=x86_64 /usr/local/bin/gosu /usr/local/bin/gosu

# armhf
COPY --from=armhf /lib/arm-linux-gnueabihf /lib/arm-linux-gnueabihf
COPY --from=armhf /usr/lib/arm-linux-gnueabihf /usr/lib/arm-linux-gnueabihf

# Allow for switching users
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
