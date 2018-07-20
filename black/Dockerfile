FROM python:3.6-alpine3.7

RUN addgroup -S black && adduser -D -S black black && \
    pip install black==18.6b4 && \
    mkdir /src

USER black

CMD ["black"]
LABEL name=black version=dev \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
