FROM alpine AS base

ENV PGBOUNCER_VERSION=1.12.0

FROM base AS build_stage

# hadolint ignore=DL3018
RUN apk --update --no-cache add \
    autoconf \
    autoconf-doc \
    automake \
    c-ares \
    c-ares-dev \
    curl \
    gcc \
    libc-dev \
    libevent \
    libevent-dev \
    libtool \
    make \
    libressl-dev \
    file \
    pkgconf

RUN curl -Lso  "/tmp/pgbouncer.tar.gz" "https://pgbouncer.github.io/downloads/files/${PGBOUNCER_VERSION}/pgbouncer-${PGBOUNCER_VERSION}.tar.gz" && \
    file "/tmp/pgbouncer.tar.gz"

WORKDIR /tmp

RUN mkdir /tmp/pgbouncer && \
    tar -zxvf pgbouncer.tar.gz -C /tmp/pgbouncer --strip-components 1

WORKDIR /tmp/pgbouncer

RUN ./configure --prefix=/usr && \
    make

FROM base

# hadolint ignore=DL3018
RUN apk --update --no-cache add \
    libevent \
    libressl \
    ca-certificates \
    c-ares

WORKDIR /etc/pgbouncer
WORKDIR /var/log/pgbouncer

RUN addgroup -S postgres && adduser -D -S postgres postgres && \
    chown -R postgres:root /etc/pgbouncer /var/log/pgbouncer

USER postgres

COPY --from=build_stage --chown=postgres ["/tmp/pgbouncer", "/opt/pgbouncer"]
COPY --chown=postgres ["entrypoint.sh", "/opt/pgbouncer"]

WORKDIR /opt/pgbouncer

ENTRYPOINT ["/opt/pgbouncer/entrypoint.sh"]

LABEL name=pgbouncer version=$PGBOUNCER_VERSION \
    maintainer="Pavel Dedik <pavel.dedik@kiwi.com>"
