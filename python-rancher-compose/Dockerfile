FROM python:3.6-alpine

ENV RANCHER_COMPOSE_VERSION v0.12.5

RUN pip install pyyaml requests && \
    apk --no-cache add unzip wget curl bash ca-certificates && \
    update-ca-certificates && \
    wget -qO- https://github.com/rancher/rancher-compose/releases/download/${RANCHER_COMPOSE_VERSION}/rancher-compose-linux-amd64-${RANCHER_COMPOSE_VERSION}.tar.gz | tar xvz -C /tmp && \
    mv /tmp/rancher-compose-${RANCHER_COMPOSE_VERSION}/rancher-compose /usr/local/bin/rancher-compose && \
    chmod +x /usr/local/bin/rancher-compose

LABEL name=python-rancher-compose version=$RANCHER_COMPOSE_VERSION \
      maintainer="Simone Esposito <simone@kiwi.com>
CMD [ "python3" ]
