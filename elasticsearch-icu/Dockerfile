FROM docker.elastic.co/elasticsearch/elasticsearch:5.3.1

ENV xpack.security.enabled=false
RUN elasticsearch-plugin install analysis-icu

LABEL name=elasticsearch-icu version=5.3.1 \
      maintainer="Simone Esposito <simone@kiwi.com>
