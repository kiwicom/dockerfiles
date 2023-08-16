FROM python:3.9-alpine

ENV version=1.4.2

RUN apk add --no-cache --virtual .build build-base cargo libffi-dev openssl-dev && \
    pip install --upgrade pip && \
    pip install setuptools poetry==$version && \
    apk del .build

LABEL name=poetry version=$version \
    maintainer="Jaroslav Sevcik <jaroslav.sevcik@kiwi.com>"

