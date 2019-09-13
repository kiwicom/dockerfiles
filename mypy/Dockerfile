FROM python:3.7-alpine

RUN addgroup -S mypy && adduser -D -S mypy mypy && \
    apk add --no-cache --virtual=.build-deps build-base && \
    pip install mypy==0.720 && \
    mkdir /src && \
    apk del .build-deps

USER mypy

CMD ["mypy"]
LABEL name=mypy version=dev \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
