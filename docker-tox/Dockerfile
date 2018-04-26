FROM docker-pyenv

RUN pyenv install 2.7.14 && \
    pyenv install 3.4.8 && \
    pyenv install 3.5.5 && \
    pyenv install 3.6.5 && \
    pyenv global 3.6.5 3.5.5 3.4.8 2.7.14 && \
    pyenv rehash && \
    pip install tox==2.9.1

LABEL name=docker-tox version=dev \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"

CMD ["tox"]
