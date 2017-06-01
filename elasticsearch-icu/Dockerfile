FROM docker.elastic.co/elasticsearch/elasticsearch:5.2.2

ENV xpack.security.enabled=false
RUN elasticsearch-plugin install analysis-icu

LABEL name=elasticsearch-icu version=5.2.2 \
      maintainer="Simone Esposito <simone@kiwi.com>
