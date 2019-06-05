FROM alpine:3.9

ENV VERSION=1.0

RUN apk --no-cache add curl ca-certificates jq && \
    update-ca-certificates

COPY wait_for_pipeline.sh /usr/bin/wait_for_pipeline

CMD ["wait_for_pipeline"]

LABEL name=gitlab-pipeline-checker version=$VERSION \
    maintainer="Pavel Dedik <pavel.dedik@kiwi.com>"
