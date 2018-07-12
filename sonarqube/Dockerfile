FROM openjdk:8-alpine

ENV SONAR_VERSION=7.2.1 \
    SONARQUBE_HOME=/opt/sonarqube \
    SONARQUBE_JDBC_USERNAME=sonar \
    SONARQUBE_JDBC_PASSWORD=sonar \
    SONARQUBE_JDBC_URL=

LABEL name=sonarqube version=$SONAR_VERSION \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"

EXPOSE 9000

RUN addgroup -S sonarqube && adduser -S -G sonarqube sonarqube

RUN set -x \
    && apk add --no-cache gnupg unzip \
    && apk add --no-cache libressl wget \
    && apk add --no-cache su-exec \
    && apk add --no-cache bash \
    # pub   rsa4096 2015-02-17 [SC]
    #       8756 C4F7 65C9 AC3C B6B8  5D62 379C E192 D401 AB61
    # uid           "Bintray (by JFrog) <bintray@bintray.com>"
    # sub   rsa4096 2015-02-17 [E]
    && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 8756C4F765C9AC3CB6B85D62379CE192D401AB61 \
    && mkdir /opt \
    && cd /opt \
    && wget -O sonarqube.zip --no-verbose https://sonarsource.bintray.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-$SONAR_VERSION.zip \
    && wget -O sonarqube.zip.asc --no-verbose https://sonarsource.bintray.com/CommercialDistribution/sonarqube-developer/sonarqube-developer-$SONAR_VERSION.zip.asc \
    && gpg --batch --verify sonarqube.zip.asc sonarqube.zip \
    && unzip sonarqube.zip \
    && mv sonarqube-$SONAR_VERSION sonarqube \
    && chown -R sonarqube:sonarqube sonarqube \
    && rm sonarqube.zip* \
    && rm -rf $SONARQUBE_HOME/bin/*

VOLUME "$SONARQUBE_HOME/data"

WORKDIR $SONARQUBE_HOME
COPY run.sh $SONARQUBE_HOME/bin/
RUN chmod +x $SONARQUBE_HOME/bin/run.sh
ENTRYPOINT ["./bin/run.sh"]
LABEL name=sonarqube version=$SONAR_VERSION \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
