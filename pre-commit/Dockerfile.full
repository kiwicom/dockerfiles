FROM python:3.9-alpine

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"
ENV version=2.9.3

RUN apk add --no-cache --virtual=.build-deps curl git linux-headers openssl-dev sqlite-dev readline-dev bzip2-dev ncurses-dev sqlite-dev patch xz-dev zlib-dev && \
    apk add --no-cache --virtual=.run-deps bash build-base curl-dev openssl readline libffi libbz2 libffi-dev bzip2 ncurses sqlite sqlite-libs zlib xz postgresql-dev ca-certificates && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 3.7.9 && \
    pyenv install 3.8.7 && \
    pyenv install 3.9.1 && \
    pyenv global 3.9.1 3.8.7 3.7.9 && \
    pyenv rehash && \
    apk add --no-cache git npm bash build-base && \
    npm config set unsafe-perm true && \
    pip install pre-commit==$version && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["pre-commit"]

LABEL name=pre-commit version=$version \
    maintainer="Kiwi.com Platform <software.platform@kiwi.com>"
