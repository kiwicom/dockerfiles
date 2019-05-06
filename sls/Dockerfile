FROM alpine:3.9

ENV SERVERLESS_VERSION=1.40.0 \
    NODE_VERSION=10.14.2-r0 \
    PYTHON3_VERSION=3.6.8-r2 \
    CLOUD_SDK_VERSION=240.0.0 \
    VAULT_VERSION=1.1.0 \
    AWS_CLI_VERSION=1.16.142 \
    CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true \
    PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin:/usr/local/vault

# Install dependencies and cleanup
RUN apk add --update unzip jq nodejs=$NODE_VERSION nodejs-npm=$NODE_VERSION python3=$PYTHON3_VERSION \
  && pip3 install --upgrade pip \
  && pip3 install --upgrade awscli==$AWS_CLI_VERSION \
  && rm -rf /var/cache/apk/* \
  && wget -qO- https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${CLOUD_SDK_VERSION}-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -xf /tmp/google-cloud-sdk.tar.gz -C /usr/local/gcloud \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm /tmp/google-cloud-sdk.tar.gz \
  && wget -qO- https://releases.hashicorp.com/vault/${VAULT_VERSION}/vault_${VAULT_VERSION}_linux_amd64.zip > /tmp/vault-linux-amd64.zip \
  && mkdir -p /usr/local/vault \
  && unzip /tmp/vault-linux-amd64.zip -d /usr/local/vault \
  && rm /tmp/vault-linux-amd64.zip

# Install gcloud beta and serverless CLI
RUN gcloud components update \
  && gcloud components install beta \
  && npm config set unsafe-perm true \
  && npm install -g serverless@$SERVERLESS_VERSION

LABEL name=sls version=$SERVERLESS_VERSION \
    maintainer="Dražen Perić <drazen.peric@kiwi.com>"
