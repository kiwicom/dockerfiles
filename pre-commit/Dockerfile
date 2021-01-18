FROM python:3.9-alpine

ENV version=2.9.3

RUN apk add --no-cache git npm bash build-base && \
    # npm needs unsafe-perm because of https://github.com/nodejs/docker-node/issues/813
    npm config set unsafe-perm true && \
    pip install pre-commit==$version

CMD ["pre-commit"]

LABEL name=pre-commit version=$version \
    maintainer="Kiwi.com Platform <software.platform@kiwi.com>"
