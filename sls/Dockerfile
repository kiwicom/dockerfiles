FROM alpine:3.9

ENV SERVERLESS_VERSION=1.50.0 \
    NODE_VERSION=10.14.2-r0 \
    CLOUD_SDK_VERSION=263.0.0 \
    VAULT_VERSION=1.2.0 \
    AWS_CLI_VERSION=1.16.241 \
    CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin:/usr/local/vault:/root/.pyenv/bin:/root/.pyenv/shims

# Install dependencies and cleanup
RUN apk add --no-cache --virtual=.build-deps curl git openssl-dev bzip2-dev zlib-dev readline-dev sqlite-dev \
  && apk add --no-cache --virutal=.run-deps bash build-base openssl readline libffi libbz2 libffi-dev sqlite sqlite-libs bzip2 zlib unzip jq nodejs=$NODE_VERSION nodejs-npm=$NODE_VERSION yarn \
  && curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash \
  && pyenv install 3.6.8 \
  && pyenv install 3.7.4 \
  && pyenv global 3.6.8 3.7.4 \
  && pyenv rehash \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade awscli==$AWS_CLI_VERSION \
  && mkdir ~/.aws \
  && wget -qO- https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -xf /tmp/google-cloud-sdk.tar.gz -C /usr/local/gcloud \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && wget -qO- https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip > /tmp/vault-linux-amd64.zip \
  && mkdir -p /usr/local/vault \
  && unzip /tmp/vault-linux-amd64.zip -d /usr/local/vault \
  && apk del .build-deps \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/* \
  && find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + \
  && find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

# Install gcloud beta and serverless CLI
RUN gcloud components update \
  && gcloud components install beta \
  && npm config set unsafe-perm true \
  && npm install -g serverless@$SERVERLESS_VERSION

LABEL name=sls version=$SERVERLESS_VERSION \
    maintainer="Dražen Perić <drazen.peric@kiwi.com>"
