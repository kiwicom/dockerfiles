FROM python:3.12-alpine

ENV version=1.10.0
RUN addgroup -S mypy && adduser -D -S mypy mypy && \
    apk add --no-cache --virtual=.build-deps build-base && \
    pip install mypy==$version && \
    mkdir /src && \
    apk del .build-deps

USER mypy

CMD ["mypy"]
LABEL name=mypy version=dev \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
