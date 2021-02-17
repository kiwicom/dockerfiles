FROM python:3.9-slim

ENV version=0.8.7
RUN addgroup --system sourcery && adduser --disabled-password --system sourcery && \
    pip install --no-cache-dir sourcery-cli==$version && \
    mkdir /src

USER sourcery

CMD ["sourcery"]
LABEL name=sourcery version=$version \
    maintainer="Alex Viscreanu <aexvir@kiwi.com>"
