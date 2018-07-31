FROM sentry:9.0.0

ENV SENTRY_VERSION=9.0

RUN apt-get update && apt-get -y install python-dev libldap2-dev libsasl2-dev libssl-dev patch && \
    pip install datadog==0.17.0 https://github.com/underyx/sentry-auth-gitlab/archive/363f54094849d3b3ee25dad6781dc700bcfcd986.zip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY *.patch /tmp/
RUN patch --strip=0 --unified --directory=/usr/local/lib/python2.7/site-packages/sentry < /tmp/0001-kiwicom-login.patch

COPY sentry.conf.py /etc/sentry/sentry.conf.py

LABEL name=sentry version=$SENTRY_VERSION \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
