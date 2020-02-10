FROM node:lts-slim

ENV SERVERLESS_VERSION=1.63.0 \
    CLOUD_SDK_VERSION=279.0.0 \
    VAULT_VERSION=1.3.2 \
    AWS_CLI_VERSION=1.17.11 \
    CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin:/usr/local/vault:/root/.pyenv/bin:/root/.pyenv/shims \
    DEBIAN_FRONTEND=noninteractive

# Install dependencies and cleanup
RUN apt update && \
    apt install -y --no-install-recommends \
      build-essential \
      ca-certificates \
      curl \
      git \
      jq \
      libbz2-dev \
      libffi-dev \
      liblzma-dev \
      libpq-dev \
      libreadline-dev \
      libsqlite3-dev \
      libssl-dev \
      tk-dev \
      unzip \
      wget \
      zlib1g-dev && \
    update-ca-certificates && \
    curl https://raw.githubusercontent.com/pyenv/pyenv-installer/dd3f7d0914c5b4a416ca71ffabdf2954f2021596/bin/pyenv-installer --output /usr/local/bin/pyenv-installer && \
    echo "449cf642f48d3baf88c390dc728f5d7684d05fe5ffec47b0a0586fa4dd63c404  /usr/local/bin/pyenv-installer" | sha256sum -c - && \
    chmod +x /usr/local/bin/pyenv-installer && \
    pyenv-installer && \
    pyenv install 3.6.10 && \
    pyenv install 3.7.6 && \
    pyenv install 3.8.1 && \
    pyenv global 3.8.1 3.7.6 3.6.10 && \
    pyenv rehash && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade awscli==$AWS_CLI_VERSION && \
    mkdir ~/.aws && \
    wget -qO- https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz && \
    mkdir -p /usr/local/gcloud && \
    tar -xf /tmp/google-cloud-sdk.tar.gz -C /usr/local/gcloud && \
    /usr/local/gcloud/google-cloud-sdk/install.sh && \
    wget -qO- https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip > /tmp/vault-linux-amd64.zip && \
    mkdir -p /usr/local/vault && \
    unzip /tmp/vault-linux-amd64.zip -d /usr/local/vault && \
    apt clean autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + || true && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' && + || true

# Install gcloud beta and serverless CLI
RUN gcloud components update && \
    gcloud components install beta && \
    npm config set unsafe-perm true && \
    npm install -g serverless@$SERVERLESS_VERSION

LABEL name=sls version=$SERVERLESS_VERSION \
    maintainer="Dražen Perić <drazen.peric@kiwi.com>"
