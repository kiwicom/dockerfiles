FROM docker:18.02

ENV GOSS_VERSION=v0.3.5 \
    DGOSS_VERSION=e6140f9045838d3b5b40ea9af787ff4ff069bbd3

RUN apk add --no-cache bash &&\
    wget https://github.com/aelsabbahy/goss/releases/download/$GOSS_VERSION/goss-linux-amd64 -O /usr/local/bin/goss && \
    wget https://raw.githubusercontent.com/aelsabbahy/goss/$DGOSS_VERSION/extras/dgoss/dgoss -O /usr/local/bin/dgoss && \
    chmod +rx /usr/local/bin/goss /usr/local/bin/dgoss

LABEL maintainer="Bence Nagy <bence@kiwi.com>"
