FROM alpine:3.9

# Set envs
ENV VERSION=1.39.1 \
  CLOUDSDK_CORE_DISABLE_USAGE_REPORTING=true \
  PATH=$PATH:/usr/local/gcloud/google-cloud-sdk/bin

# Install dependencies and cleanup
RUN apk add --update curl nodejs=10.14.2-r0 nodejs-npm=10.14.2-r0 python3=3.6.8-r1 \
  && rm -rf /var/cache/apk/* \
  && curl -Ss https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-239.0.0-linux-x86_64.tar.gz > /tmp/google-cloud-sdk.tar.gz \
  && mkdir -p /usr/local/gcloud \
  && tar -C /usr/local/gcloud -xf /tmp/google-cloud-sdk.tar.gz \
  && /usr/local/gcloud/google-cloud-sdk/install.sh \
  && rm /tmp/google-cloud-sdk.tar.gz

# Install gcloud beta and serverless CLI
RUN gcloud components update \
  && gcloud components install beta \
  && npm config set unsafe-perm true \
  && npm install -g serverless@$VERSION

LABEL name=sls version=$VERSION \
    maintainer="Dražen Perić <drazen.peric@kiwi.com>"
