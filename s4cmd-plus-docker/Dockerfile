FROM python:2-alpine

RUN apk --no-cache add bash docker && \
    pip install s4cmd && \
    chmod +x /usr/local/bin/s4cmd

LABEL maintainer="Simone Esposito <simone@kiwi.com>"
CMD ["s4cmd"]
