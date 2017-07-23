FROM docker:1.12

RUN apk add --no-cache tini

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/sbin/tini", "--"]
CMD ["/entrypoint.sh"]
