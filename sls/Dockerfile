FROM node:lts-slim

ENV SERVERLESS_VERSION=3.27.0 \
    VAULT_VERSION=1.4.3 \
    AWS_CLI_VERSION=1.17.11 \
    PATH=$PATH:/bin:/usr/local/vault:/root/.pyenv/bin:/root/.pyenv/shims:/tfenv/bin \
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
    pyenv install 3.8.1 && \
    pyenv install 3.9.16 && \
    pyenv global 3.9.16 3.8.1 && \
    pyenv rehash && \
    pip3 install --upgrade pip && \
    pip3 install --upgrade awscli==$AWS_CLI_VERSION && \
    mkdir ~/.aws && \
    wget -qO- https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip > /tmp/vault-linux-amd64.zip && \
    mkdir -p /usr/local/vault && \
    unzip /tmp/vault-linux-amd64.zip -d /usr/local/vault && \
    apt clean autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + || true && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' && + || true

# Install gcloud beta and serverless CLI
RUN npm install -g serverless@$SERVERLESS_VERSION

LABEL name=sls version=$SERVERLESS_VERSION \
    maintainer="Jurica Grgicevic <jurica.grgicevic@kiwi.com>"
