FROM python:3.10-alpine

ENV version=22.3.0
RUN apk add --no-cache --virtual=.build-deps build-base && \
    addgroup -S black && adduser -D -S black black && \
    pip install --no-cache-dir black==$version && \
    apk del .build-deps && \
    mkdir /src

USER black

CMD ["black"]
LABEL name=black version=$version \
    maintainer="Kiwi.com Platform <software.platform@kiwi.com>"
