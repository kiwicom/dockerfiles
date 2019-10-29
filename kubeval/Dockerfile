FROM alpine

ENV KUBEVAL_VERSION=0.14.0 \
    KUBECTL_VERSION=1.16.2

RUN apk add --no-cache git && \
    wget https://github.com/instrumenta/kubeval/releases/download/0.14.0/kubeval-linux-amd64.tar.gz && \
    tar xf kubeval-linux-amd64.tar.gz && \
    mv kubeval /usr/local/bin && \
    chmod +x /usr/local/bin/kubeval && \
    rm -rf kubeval-linux-amd64.tar.gz && \
    \
    wget https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && \
    mv kubectl /usr/local/bin/kubectl && \
    chmod +x /usr/local/bin/kubectl

COPY ./analyse /usr/local/bin

CMD ["/usr/local/bin/analyse"]

LABEL name=kubeval version=$KUBEVAL_VERSION \
    maintainer="Michal Cyprian michal.cyprian@kiwi.com"
