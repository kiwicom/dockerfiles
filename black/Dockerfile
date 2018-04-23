FROM python:3.6-alpine3.7

RUN addgroup -S black && adduser -D -S black black && \
    pip install black==18.6b4 && \
    mkdir /src

LABEL name=black version=dev \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"

USER black

CMD ["black"]
