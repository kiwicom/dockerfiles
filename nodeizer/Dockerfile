FROM node:12-alpine

RUN addgroup -S peasant && adduser -D -S peasant peasant &&\
    apk add --no-cache git openssh-client

USER peasant
