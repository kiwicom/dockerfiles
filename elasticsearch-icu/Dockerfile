FROM docker.elastic.co/elasticsearch/elasticsearch:7.17.29

ENV xpack.security.enabled=false
RUN elasticsearch-plugin install analysis-icu

LABEL name=elasticsearch-icu version=7.8.1 \
      maintainer="Platform team <engineering.platform.software@kiwi.com>"
