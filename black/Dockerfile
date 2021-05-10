FROM python:3.9-alpine

ENV version=21.5b0
RUN apk add --no-cache --virtual=.build-deps build-base && \
    addgroup -S black && adduser -D -S black black && \
    pip install --no-cache-dir black==$version && \
    apk del .build-deps && \
    mkdir /src

USER black

CMD ["black"]
LABEL name=black version=$version \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
