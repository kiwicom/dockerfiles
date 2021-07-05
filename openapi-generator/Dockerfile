FROM alpine:3.13

RUN set -x && \
    apk add --no-cache bash ca-certificates git icu-dev python3-dev openssl nodejs npm openjdk8 && \
    update-ca-certificates

ENV MAVEN_VERSION=3.8.1
ENV MAVEN_HOME=/usr/share/maven

# Installing dependencies
RUN python3 -m ensurepip --upgrade && \
    pip3 install prance[osv,cli] && \
    npm install -g typescript yarn

# Installing maven
RUN cd /tmp \
   && wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz \
   && wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz.sha512 \
   && echo -e "$(cat apache-maven-$MAVEN_VERSION-bin.tar.gz.sha512)  apache-maven-$MAVEN_VERSION-bin.tar.gz" | sha512sum -c - \
   && tar zxf apache-maven-$MAVEN_VERSION-bin.tar.gz \
   && rm -rf apache-maven-$MAVEN_VERSION-bin.tar.gz \
   && rm -rf *.sha1 \
   && mv ./apache-maven-$MAVEN_VERSION /usr/share/maven \
   && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn

ENV GEN_DIR /opt/openapi-generator
WORKDIR ${GEN_DIR}
VOLUME  ${MAVEN_HOME}/.m2/repository

# Required from a licensing standpoint
COPY src/LICENSE ${GEN_DIR}

# Required to compile openapi-generator
COPY src/google_checkstyle.xml ${GEN_DIR}

# Modules are copied individually here to allow for caching of docker layers between major.minor versions
COPY src/modules/openapi-generator-gradle-plugin ${GEN_DIR}/modules/openapi-generator-gradle-plugin
COPY src/modules/openapi-generator-maven-plugin ${GEN_DIR}/modules/openapi-generator-maven-plugin
COPY src/modules/openapi-generator-online ${GEN_DIR}/modules/openapi-generator-online
COPY src/modules/openapi-generator-cli ${GEN_DIR}/modules/openapi-generator-cli
COPY src/modules/openapi-generator-core ${GEN_DIR}/modules/openapi-generator-core
COPY src/modules/openapi-generator ${GEN_DIR}/modules/openapi-generator
COPY src/pom.xml ${GEN_DIR}

# Pre-compile openapi-generator-cli
RUN mvn -am -pl "modules/openapi-generator-cli" package

# This exists at the end of the file to benefit from cached layers when modifying docker-entrypoint.sh.
COPY src/docker-entrypoint.sh /usr/local/bin/
RUN ln -s /usr/local/bin/docker-entrypoint.sh /usr/local/bin/openapi-generator

ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["help"]
