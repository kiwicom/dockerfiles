FROM python:3.9-alpine

ENV version=5.7.0

RUN addgroup -S isort && adduser -D -S isort isort && \
    pip install isort==$version && \
    mkdir /src

USER isort

CMD ["isort"]
LABEL name=isort version=$version \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
