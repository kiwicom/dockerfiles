FROM openjdk:11-jre-slim

ENV VERSION=4.2.0.1873 \
    PATH=$PATH:/opt/sonar-scanner/bin

RUN apt update && \
    apt install -y --no-install-recommends build-essential python3-pip wget git nodejs ca-certificates unzip && \
    update-ca-certificates && \
    pip3 install setuptools && \
    pip3 install pylint~=2.4.4 && \
    wget -O /tmp/sonar.zip https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-$VERSION-linux.zip && \
    unzip /tmp/sonar.zip -d /tmp && \
    mkdir -p /opt/sonar-scanner && \
    cp -R /tmp/sonar-scanner-$VERSION-linux/* /opt/sonar-scanner/ && \
    sed -i 's/use_embedded_jre=true/use_embedded_jre=false/' $(which sonar-scanner) && \
    apt clean autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    rm -rf /tmp/* /opt/sonar-scanner/jre/

COPY bin/* /usr/local/bin/

LABEL name=sonar-scanner version=$VERSION \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"
