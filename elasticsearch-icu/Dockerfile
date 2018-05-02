FROM docker.elastic.co/elasticsearch/elasticsearch:5.6.9

ENV xpack.security.enabled=false
RUN elasticsearch-plugin install analysis-icu

LABEL name=elasticsearch-icu version=5.6.9 \
      maintainer="Simone Esposito <simone@kiwi.com>"
