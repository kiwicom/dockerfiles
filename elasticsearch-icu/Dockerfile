FROM docker.elastic.co/elasticsearch/elasticsearch:6.7.1

ENV xpack.security.enabled=false
RUN elasticsearch-plugin install analysis-icu

LABEL name=elasticsearch-icu version=6.7.1 \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"
