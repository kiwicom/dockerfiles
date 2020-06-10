FROM python:3.8-alpine

RUN apk add --no-cache python3-dev gcc musl-dev libffi-dev openssl-dev && \
    pip install --upgrade pip && \
    pip install setuptools poetry==1.0.9

LABEL name=poetry version=dev \
    maintainer="Jaroslav Sevcik <jaroslav.sevcik@kiwi.com>"
