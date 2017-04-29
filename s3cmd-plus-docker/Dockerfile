FROM python:2-alpine

RUN apk --no-cache add docker && \
    pip install s3cmd

LABEL maintainer="Simone Esposito <simone@kiwi.com>"
CMD ["s3cmd"]
