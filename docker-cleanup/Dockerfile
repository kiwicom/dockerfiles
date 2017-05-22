FROM alpine:3.5

# Generic docker-cleanup tool
# Currently runs docker-gc & removes dangling volumes

# Running:
# docker run -v/var/run/docker.sock:/var/run/docker.sock kiwicom/docker-cleanup

ARG DOCKER_VERSION=1.13.1
RUN apk --no-cache add bash curl tzdata && \
  curl -fsSL https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz | \
  tar --strip-components=1 -xvzf - -C /usr/local/bin

COPY bin/* /usr/local/bin/

ENV FORCE_IMAGE_REMOVAL=1 \
    FORCE_CONTAINER_REMOVAL=1
CMD ["docker-cleanup"]
VOLUME ["/var/run/docker.sock"]
LABEL name=docker-cleanup version=dev \
      maintainer="Simone Esposito <simone@kiwi.com>" 
