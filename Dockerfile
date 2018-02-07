FROM nginx:1.12.2

MAINTAINER edenb

WORKDIR /root

ENV DOCKER_GEN_VERSION 0.7.3
ENV ARCH armhf

ADD https://github.com/just-containers/s6-overlay/releases/download/v1.21.2.2/s6-overlay-$ARCH.tar.gz /tmp/
ADD https://github.com/jwilder/docker-gen/releases/download/$DOCKER_GEN_VERSION/docker-gen-linux-$ARCH-$DOCKER_GEN_VERSION.tar.gz /tmp/
ADD https://raw.githubusercontent.com/diafygi/acme-tiny/19b274cf38544ad9ccc69aa140969c30c4e0d8fd/acme_tiny.py /bin/acme_tiny

RUN tar xzf /tmp/s6-overlay-$ARCH.tar.gz -C / &&\
    tar -C /bin -xzf /tmp/docker-gen-linux-$ARCH-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/docker-gen-linux-$ARCH-$DOCKER_GEN_VERSION.tar.gz && \
    rm /tmp/s6-overlay-$ARCH.tar.gz && \
    rm /etc/nginx/conf.d/default.conf && \
    apt-get update && \
    apt-get install -y python ruby cron iproute2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY ./fs_overlay /

RUN chmod a+x /bin/* && \
    chmod a+x /etc/cron.weekly/renew_certs

VOLUME /var/lib/https-portal

ENTRYPOINT ["/init"]
