FROM alpine:3

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"

RUN apk add --no-cache --virtual=.build-deps curl git linux-headers openssl-dev sqlite-dev readline-dev bzip2-dev ncurses-dev sqlite-dev patch xz-dev zlib-dev && \
    apk add --no-cache --virtual=.run-deps bash build-base openssl readline libffi libbz2 libffi-dev bzip2 ncurses sqlite sqlite-libs zlib xz postgresql-dev ca-certificates && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 2.7.17 && \
    pyenv install 3.5.8 && \
    pyenv install 3.6.10 && \
    pyenv install 3.7.6 && \
    pyenv install 3.8.1 && \
    pyenv global 3.8.1 3.7.6 3.6.10 3.5.8 2.7.17 && \
    pyenv rehash && \
    pip install tox==3.14.3 && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["tox"]
LABEL name=tox version=3.14.3 \
    maintainer="Alex Viscreanu aexvir@kiwi.com"
