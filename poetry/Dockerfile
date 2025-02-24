FROM python:3.12-slim

ENV version=1.8.5

RUN apt update && \
    apt install -y build-essential cargo libffi-dev libssl-dev && \
    pip install --upgrade pip && \
    pip install setuptools poetry==$version

LABEL name=poetry version=$version \
    maintainer="Kiwi.com Platform <software.platform@kiwi.com>"

