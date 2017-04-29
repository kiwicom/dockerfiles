FROM node:7-slim

RUN apt-get -y update \
  && apt-get -y install git libgtk2.0-0 libnotify4 libnotify-dev libgconf-2-4 libnss3 libxss1 xvfb \
  && npm set progress=false \
  && npm install --global cypress-cli \
  && cypress install \
  && cypress verify \
  && rm -rf /var/lib/apt/lists/* /var/apt/cache/* /tmp/*

LABEL name=cypress-cli version=dev \
      maintainer="Simone Esposito <simone@kiwi.com>"

CMD ['cypress', 'run']
