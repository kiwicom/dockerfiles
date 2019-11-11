FROM python:3.7-alpine

RUN addgroup -S isort && adduser -D -S isort isort && \
    pip install isort==4.3.21 && \
    mkdir /src

USER isort

CMD ["isort"]
LABEL name=isort version=dev \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
