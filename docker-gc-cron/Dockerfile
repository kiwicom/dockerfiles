FROM alpine:3.5

# Fork of https://github.com/clockworksoul/docker-gc-cron

ARG DOCKER_VERSION=1.11.1

# We get curl so that we can avoid a separate ADD to fetch the Docker binary, and then we'll remove it.
# Blatantly "borrowed" from Spotify's spotify/docker-gc image. Thanks, guys!
RUN apk --no-cache add bash curl tzdata && \
  cd /tmp/ && \
  curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-${DOCKER_VERSION}.tgz && \
  tar zxf docker-${DOCKER_VERSION}.tgz && \
  mkdir -p /usr/local/bin/ && \
  mv /tmp/docker/docker /usr/local/bin/ && \
  curl -sSL https://raw.githubusercontent.com/spotify/docker-gc/master/docker-gc > /usr/bin/docker-gc && \
  chmod +x /usr/local/bin/docker /usr/bin/docker-gc && \
  apk del curl && \
  rm -rf /tmp/* /var/cache/apk/*

COPY default-docker-gc-exclude /etc/docker-gc-exclude
COPY executed-by-cron.sh /executed-by-cron.sh
COPY generate-crontab.sh /generate-crontab.sh

RUN chmod 0755 /generate-crontab.sh && \
  chmod 0755 /executed-by-cron.sh && \
  chmod 0644 /etc/docker-gc-exclude 

CMD /generate-crontab.sh > /var/log/cron.log 2>&1 && \
  crontab crontab.tmp && \
  /usr/sbin/crond && \
  tail -f /var/log/cron.log

ENV CLEAN_UP_VOLUMES=1

LABEL name=docker-gc-cron version=dev \
      maintainer="Simone Esposito <simone@kiwi.com>" 
