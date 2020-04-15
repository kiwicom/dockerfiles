FROM python:3.8-alpine

ENV version=2.2.0

RUN apk add --no-cache git npm bash build-base && \
    # npm needs unsafe-perm because of https://github.com/nodejs/docker-node/issues/813
    npm config set unsafe-perm true && \
    pip install pre-commit==$version

CMD ["pre-commit"]

LABEL name=pre-commit version=$version \
    maintainer="Kiwi.com Platform <platform.software@kiwi.com>"
