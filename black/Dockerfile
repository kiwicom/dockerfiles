FROM python:3.7-alpine

RUN addgroup -S black && adduser -D -S black black && \
    pip install black==18.9b0 && \
    mkdir /src

USER black

CMD ["black"]
LABEL name=black version=dev \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
