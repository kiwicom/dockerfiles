FROM sentry:9.1.2

ENV SENTRY_VERSION=9.1.2

RUN apt update && apt -y install python-dev libldap2-dev libsasl2-dev libssl-dev patch libgeoip-dev && \
    pip install datadog==0.29.3 https://github.com/underyx/sentry-auth-gitlab/archive/363f54094849d3b3ee25dad6781dc700bcfcd986.zip && \
    apt clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# https://github.com/getsentry/onpremise/issues/201
RUN PSYCOPG=$(pip freeze | grep psycopg2) && \
    pip uninstall -y $PSYCOPG && \
    pip install --no-binary :all: $PSYCOPG

# https://github.com/getsentry/docker-sentry/issues/197
COPY optional-requirements.txt ./
RUN pip install --no-cache-dir -r optional-requirements.txt && \
    rm optional-requirements.txt

COPY *.patch /tmp/
RUN patch --strip=0 --unified --directory=/usr/local/lib/python2.7/site-packages/sentry < /tmp/0001-kiwicom-login.patch
RUN patch --strip=0 --unified --directory=/usr/local/lib/python2.7/site-packages/sentry_plugins < /tmp/0002-sentry-plugins-pagerduty.patch
RUN patch --strip=0 --unified --directory=/usr/local/lib/python2.7/site-packages/sentry < /tmp/0003-slack-integration-update.patch

LABEL name=sentry version=$SENTRY_VERSION \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
