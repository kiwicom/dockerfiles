FROM alpine:3

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"
ENV version=3.22.0

RUN apk add --no-cache --virtual=.build-deps bzip2-dev cargo curl git linux-headers ncurses-dev openssl-dev patch readline-dev sqlite-dev sqlite-dev xz-dev zlib-dev && \
    apk add --no-cache --virtual=.run-deps bash build-base curl-dev openssl readline libffi libbz2 libffi-dev bzip2 ncurses sqlite sqlite-libs zlib xz postgresql-dev ca-certificates && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 3.5.10 && \
    pyenv install 3.6.12 && \
    pyenv install 3.7.9 && \
    pyenv install 3.8.7 && \
    pyenv install 3.9.1 && \
    pyenv global 3.9.1 3.8.7 3.7.9 3.6.12 3.5.10 && \
    pyenv rehash && \
    pip install tox==$version && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["tox"]
LABEL name=tox version=$version \
    maintainer="Alex Viscreanu aexvir@kiwi.com"
