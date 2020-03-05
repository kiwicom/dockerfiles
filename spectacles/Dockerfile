FROM python:3.8-alpine

ENV version=0.1.1
WORKDIR /src
RUN apk add --no-cache --virtual=.build-deps build-base && \
    addgroup -S spectacles && adduser -D -S spectacles spectacles && \
    pip install --no-cache-dir spectacles==$version && \
    apk del .build-deps

USER spectacles

CMD ["spectacles"]
LABEL name=spectacles version=$version \
    maintainer="Radka Meres <radka.meres@kiwi.com>"
