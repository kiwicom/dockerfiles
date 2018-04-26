FROM alpine:3.7

RUN apk add --no-cache curl ca-certificates bash git openssl-dev readline-dev bzip2-dev sqlite-dev linux-headers build-base && \
    curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer -o /pyenv-installer && \
    touch /root/.bashrc && \
    ln -s /root/.bashrc /root/.bash_profile && \
    bash /pyenv-installer && \
    rm /pyenv-installer && \
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile && \
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile && \
    echo 'eval "$(pyenv init -)"' >> ~/.bash_profile && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile

ENV HOME  /root
ENV PYENV_ROOT $HOME/.pyenv
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH

RUN git clone https://github.com/momo-lab/pyenv-install-latest.git "$(pyenv root)"/plugins/pyenv-install-latest && \
    pyenv update

LABEL name=docker-pyenv version=dev \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"
