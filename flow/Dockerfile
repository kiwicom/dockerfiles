FROM alpine:3.6

ENV FLOW_VERSION=0.57.3

RUN apk --no-cache --virtual=.build-deps add openssl ca-certificates && \
    update-ca-certificates && \
    
    wget -O /etc/apk/keys/sgerrand.rsa.pub https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.25-r0/glibc-2.25-r0.apk -O /tmp/glibc.apk && \
    apk add /tmp/glibc.apk && \

    wget -O /tmp/flow.zip https://github.com/facebook/flow/releases/download/v${FLOW_VERSION}/flow-linux64-v${FLOW_VERSION}.zip && \
    unzip /tmp/flow.zip -d /tmp/ && \
    mv /tmp/flow/flow /usr/local/bin/flow && \
    chmod 0777 /usr/local/bin/flow && \
    
    apk del .build-deps && \
    rm -rf /var/cache/* /tmp/*


VOLUME /app
WORKDIR /app

CMD ["flow", "check"]
LABEL name=flow version=dev \
      maintainer="Simone Esposito <simone@kiwi.com>"

