FROM zenika/kotlin:1.4-jdk12-alpine

ENV VERSION=1.0.0-RC14 \
    PATH=$PATH:/opt/detekt/bin

RUN wget https://github.com/arturbosch/detekt/archive/$VERSION.tar.gz -O - | tar -xz -C /tmp && \
    cd /tmp/detekt-$VERSION && \
    ./gradlew build shadowJar && \
    mkdir -p /opt/detekt/bin && \
    mv -v ./detekt-cli/build/libs/* /opt/detekt && \
    echo -e '#!/bin/bash\njava -jar /opt/detekt/detekt-cli-$VERSION-all.jar "$@"' > /opt/detekt/bin/detekt && \
    chmod +x /opt/detekt/bin/detekt && \
    rm -r /tmp/detekt-$VERSION

LABEL name=detekt version=$VERSION \
    maintainer="Pavel Dedik <pavel.dedik@kiwi.com>"
