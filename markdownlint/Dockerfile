FROM node:12-alpine

ENV MARKDOWNLINT_VERSION=0.19.0

RUN npm install -g markdownlint-cli@${MARKDOWNLINT_VERSION}

CMD ["markdownlint"]

LABEL name=markdownlint version=$MARKDOWNLINT_VERSION \
    maintainer="Pavel Dedik <pavel.dedik@kiwi.com>"
