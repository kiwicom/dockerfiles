FROM python:3.9.6-alpine3.14@sha256:3e7e8a57a959c393797f0c90fa7b0fdbf7a40c4a274028e3f28a4f33d4783866

# Checksum from https://github.com/yannh/kubeconform/releases/latest
ENV version=0.4.8
ARG KUBECONFORM_VERSION=${version}
# Checksum from https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
ARG KUBECTL_VERSION=1.21.3

RUN apk add --no-cache git~=2.32 && \
    mkdir -p /tmp/onbuild && \
    cd /tmp/onbuild && \
    echo "DOWNLOADING KUBECONFORM v${KUBECONFORM_VERSION}" && \
    echo "4a1be7a6e93ff16e7ad49f291215b3752719cb98a607dc7ab953d781013810b7  -" >kubeconform.sha256 && \
    wget -qO- "https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz" | \
    tee kubeconform.tar.gz | \
    sha256sum -c kubeconform.sha256 && \
    tar xf kubeconform.tar.gz && \
    chmod +x kubeconform && \
    mv kubeconform /usr/local/bin/kubeconform && \
    echo "DOWNLOADING KUBECTL v${KUBECTL_VERSION}" && \
    echo "631246194fc1931cb897d61e1d542ef2321ec97adcb859a405d3b285ad9dd3d6  -" >kubectl.sha256 && \
    wget -qO- "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" | \
    tee /usr/local/bin/kubectl | \
    sha256sum -c kubectl.sha256 && \
    chmod +x /usr/local/bin/kubectl && \
    cd / && \
    rm -rf /tmp/onbuild

COPY ./analyse.py /usr/local/bin/analyse

CMD ["/usr/local/bin/analyse"]

LABEL name=kubeconform \
      version.kubeconform=${KUBECONFORM_VERSION} \
      version.kubectl=${KUBECTL_VERSION}
