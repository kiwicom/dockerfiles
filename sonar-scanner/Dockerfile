FROM openjdk:8-jre-alpine

ENV VERSION=3.2.0.1227 \
    PATH=$PATH:/opt/sonar-scanner/bin

RUN apk add --no-cache --virtual=.run-deps bash ca-certificates git nodejs python3 && \
    apk add --no-cache --virtual=.build-deps build-base python3-dev unzip wget && \
    python3 -m pip install pylint~=2.2.2 && \
    wget -O /tmp/sonar.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$VERSION-linux.zip && \
    unzip /tmp/sonar.zip -d /tmp && \
    mkdir -p /opt/sonar-scanner && \
    cp -R /tmp/sonar-scanner-$VERSION-linux/* /opt/sonar-scanner/ && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/' $(which sonar-scanner) && \
    apk del .build-deps && \
    rm -rf /tmp/* /opt/sonar-scanner/jre/

COPY bin/* /usr/local/bin/

LABEL name=sonar-scanner version=$VERSION \
      maintainer="Bence Nagy <bence@kiwi.com>"
