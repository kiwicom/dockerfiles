FROM alpine:3.8

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"

RUN apk add --no-cache --virtual=.build-deps curl git linux-headers openssl-dev sqlite-dev readline-dev libffi-dev bzip2-dev ncurses-dev sqlite-dev patch && \
    apk add --no-cache --virtual=.run-deps bash build-base openssl readline libffi libbz2 bzip2 ncurses sqlite sqlite-libs ca-certificates && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 2.7.14 && \
    pyenv install 3.4.8 && \
    pyenv install 3.5.5 && \
    pyenv install 3.6.5 && \
    pyenv install 3.7.0 && \
    pyenv global 3.7.0 3.6.5 3.5.5 3.4.8 2.7.14 && \
    pyenv rehash && \
    pip install tox==3.5.0 && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["tox"]
LABEL name=tox version=dev \
    maintainer="Alex Viscreanu aexvir@kiwi.com"
