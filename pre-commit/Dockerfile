FROM python:3.7-alpine

RUN apk add --no-cache git npm bash build-base && \
    npm config set unsafe-perm true && \  # https://github.com/nodejs/docker-node/issues/813
    pip install pre-commit==1.18.3

CMD ["pre-commit"]

LABEL name=pre-commit version=1.18.3 \
    maintainer="Jan Bednarik jan.bednarik@kiwi.com"
