FROM docker:18.05

ENV GOSS_VERSION=v0.3.6 \
    DGOSS_VERSION=3c51e31c2083b61c24c346e37d08be39d8149f51

RUN apk add --no-cache bash &&\
    wget https://github.com/aelsabbahy/goss/releases/download/$GOSS_VERSION/goss-linux-amd64 -O /usr/local/bin/goss && \
    wget https://raw.githubusercontent.com/aelsabbahy/goss/$DGOSS_VERSION/extras/dgoss/dgoss -O /usr/local/bin/dgoss && \
    chmod +rx /usr/local/bin/goss /usr/local/bin/dgoss

LABEL maintainer="Bence Nagy <bence@kiwi.com>"
