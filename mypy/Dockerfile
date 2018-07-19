FROM python:3.7-alpine3.8

RUN addgroup -S mypy && adduser -D -S mypy mypy && \
    apk add --no-cache --virtual=.build-deps build-base && \
    pip install mypy==0.620 && \
    mkdir /src && \
    apk del .build-deps

USER mypy

CMD ["mypy"]
LABEL name=mypy version=dev \
    maintainer="Bence Nagy <bence@kiwi.com>"
