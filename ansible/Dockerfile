FROM python:3.6-alpine3.7

RUN apk add --no-cache --virtual=.build-deps libffi-dev openssl-dev build-base && \
    apk add --no-cache --virtual=.run-deps openssh-client ca-certificates openssl && \
    pip install --no-cache-dir cffi==1.11.5 ansible==2.5.5 && \
    apk del .build-deps && \
    ln -s /usr/local/bin/python /usr/bin/python

CMD ["ansible-playbook", "--version"]

LABEL name=ansible version=2.5.5 \
      maintainer="Adam Janis <adam.janis@kiwi.com>"
