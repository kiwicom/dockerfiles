FROM alpine:3.13.1@sha256:3747d4eb5e7f0825d54c8e80452f1e245e24bd715972c919d189a62da97af2ae

# Checksum from https://github.com/yannh/kubeconform/releases/latest
ENV version=0.4.7
ARG KUBECONFORM_VERSION=${version}
# Checksum from https://dl.k8s.io/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl.sha256
ARG KUBECTL_VERSION=1.20.2

RUN apk add --no-cache git~=2.30 && \
    mkdir -p /tmp/onbuild && \
    cd /tmp/onbuild && \
    echo "DOWNLOADING KUBECONFORM v${KUBECONFORM_VERSION}" && \
    echo "d7a5cb848b783c15119316d716d8a74bf11c9e3ab050f3adf28e0678a6018467  -" >kubeconform.sha256 && \
    wget -qO- "https://github.com/yannh/kubeconform/releases/download/v${KUBECONFORM_VERSION}/kubeconform-linux-amd64.tar.gz" | \
    tee kubeconform.tar.gz | \
    sha256sum -c kubeconform.sha256 && \
    tar xf kubeconform.tar.gz && \
    chmod +x kubeconform && \
    mv kubeconform /usr/local/bin/kubeconform && \
    echo "DOWNLOADING KUBECTL v${KUBECTL_VERSION}" && \
    echo "2583b1c9fbfc5443a722fb04cf0cc83df18e45880a2cf1f6b52d9f595c5beb88  -" >kubectl.sha256 && \
    wget -qO- "https://dl.k8s.io/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" | \
    tee /usr/local/bin/kubectl | \
    sha256sum -c kubectl.sha256 && \
    chmod +x /usr/local/bin/kubectl && \
    cd / && \
    rm -rf /tmp/onbuild

COPY ./analyse /usr/local/bin

CMD ["/usr/local/bin/analyse"]

LABEL name=kubeconform \
      version.kubeconform=${KUBECONFORM_VERSION} \
      version.kubectl=${KUBECTL_VERSION}
