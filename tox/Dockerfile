FROM alpine:3

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"
ENV TOX_VERSION="3.15.2"

RUN apk add --no-cache --virtual=.build-deps curl git linux-headers openssl-dev sqlite-dev readline-dev bzip2-dev ncurses-dev sqlite-dev patch xz-dev zlib-dev && \
    apk add --no-cache --virtual=.run-deps bash build-base curl-dev openssl readline libffi libbz2 libffi-dev bzip2 ncurses sqlite sqlite-libs zlib xz postgresql-dev ca-certificates && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 2.7.18 && \
    pyenv install 3.5.9 && \
    pyenv install 3.6.10 && \
    pyenv install 3.7.7 && \
    pyenv install 3.8.3 && \
    pyenv global 3.8.3 3.7.7 3.6.10 3.5.9 2.7.18 && \
    pyenv rehash && \
    pip install tox==$TOX_VERSION && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["tox"]
LABEL name=tox version=$TOX_VERSION \
    maintainer="Alex Viscreanu aexvir@kiwi.com"
