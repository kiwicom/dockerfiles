FROM python:3.9-slim

ENV PATH="$PATH:/root/.pyenv/bin:/root/.pyenv/shims"
ENV version=2.9.3

RUN apt update && apt install -y git golang bash curl build-essential libffi-dev libssl-dev libbz2-dev libncursesw5-dev libgdbm-dev liblzma-dev libsqlite3-dev tk-dev uuid-dev libreadline-dev nodejs npm zlib1g-dev && \
    curl --location https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash && \
    pyenv update && \
    pyenv install 3.7.9 && \
    pyenv install 3.8.7 && \
    pyenv install 3.9.1 && \
    pyenv global 3.9.1 3.8.7 3.7.9 && \
    pyenv rehash && \
    npm config set unsafe-perm true && \
    pip install pre-commit==$version && \
    rm -rf /var/cache/apk/* && \
    rm -rf /tmp/* && \
    apt clean autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /tmp/* && \
    find /root/.pyenv/versions -type d '(' -name '__pycache__' -o -name 'test' -o -name 'tests' ')' -exec rm -rfv '{}' + && \
    find /root/.pyenv/versions -type f '(' -name '*.py[co]' -o -name '*.exe' ')' -exec rm -fv '{}' +

CMD ["pre-commit"]

LABEL name=pre-commit version=$version \
    maintainer="Kiwi.com Platform <software.platform@kiwi.com>"
