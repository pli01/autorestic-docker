FROM debian:buster

ARG MIRROR_DEBIAN
ARG MIRROR_DOCKER
ARG MIRROR_DOCKER_KEY

RUN useradd autorestic -G sudo \
    && mkdir -p /home/autorestic \
    && chown -Rh autorestic:autorestic /home/autorestic

# System dependencies
# Custom packages
ARG DEBIAN_FRONTEND=noninteractive
ARG PACKAGE_CUSTOM="locales locales-all \
     acl curl bzip2 wget git unzip zip \
     sudo make git unzip apt-transport-https ca-certificates gnupg2 software-properties-common \
     jq"

RUN echo "$http_proxy $no_proxy" && set -x && [ -z "$MIRROR_DEBIAN" ] || \
    sed -i.orig -e "s|http://deb.debian.org/debian|$MIRROR_DEBIAN/debian10|g ; s|http://security.debian.org/debian-security|$MIRROR_DEBIAN/debian10-security|g" /etc/apt/sources.list ; cat /etc/apt/sources.list /etc/apt/sources.list.orig ; \
    apt-get -q update \
    && echo "+ Install requirements" \
    && apt-get install -qy --no-install-recommends $PACKAGE_CUSTOM \
    && rm -rf /var/lib/apt/lists/* \
    &&  echo "+ add autorestic sudo" \
    &&  echo "autorestic    ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers 

## Add docker-ce
#RUN curl -fsSL ${MIRROR_DOCKER_KEY:-https://download.docker.com/linux/debian/gpg} | apt-key add - \
#    && add-apt-repository \
#     "deb [arch=amd64] ${MIRROR_DOCKER:-https://download.docker.com/linux/debian} $(lsb_release -cs) stable" \
#    && apt-get -qq update -qy \
#    && apt-get -qq install -qy --allow-unauthenticated docker-ce \
#    && adduser autorestic docker
#
# Download and extract autorestic
RUN cd /home/autorestic \
    && echo "+ Downloading autorestic" \
    && curl -s https://raw.githubusercontent.com/CupCakeArmy/autorestic/master/install.sh | bash

# Entry point
WORKDIR /home/autorestic
USER autorestic

COPY run.sh /home/autorestic/

ENV  RESTIC_CACHE_DIR=/autorestic/cache
ENTRYPOINT [ "/home/autorestic/run.sh" ]
