FROM alpine

ENV version=0.15.0

ENV KUBEVAL_VERSION=${version} \
    KUBECTL_VERSION=1.19.2

RUN apk add --no-cache git && \
    wget https://github.com/instrumenta/kubeval/releases/download/${KUBEVAL_VERSION}/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin && \
    chmod +x /usr/local/bin/kubeval && \
    rm -rf kubeval-linux-amd64.tar.gz && \
    wget https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

COPY ./analyse /usr/local/bin

CMD ["/usr/local/bin/analyse"]

LABEL name=kubeval version=$version \
    maintainer="Michal Cyprian michal.cyprian@kiwi.com"
