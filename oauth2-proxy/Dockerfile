FROM buildpack-deps:jessie-curl

ENV OAUTH2_DOWNLOAD_URL=https://github.com/bitly/oauth2_proxy/releases/download/v2.2/oauth2_proxy-2.2.0.linux-amd64.go1.8.1.tar.gz \
    PATH=/opt/oauth2-proxy/bin:$PATH

RUN mkdir -p /opt/oauth2-proxy/bin && mkdir /opt/oauth2-proxy/etc && \
    curl -L -k $OAUTH2_DOWNLOAD_URL | tar xz --strip-components 1 -C /opt/oauth2-proxy/bin

CMD oauth2_proxy -config=/opt/oauth2-proxy/etc/config

LABEL name=oauth2-proxy version=2.2.0 maintainer="Tomas Fedor <tomas.fedor@kiwi.com>"
