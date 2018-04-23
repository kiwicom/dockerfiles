FROM python:3.6-alpine3.7

WORKDIR /app
RUN pip install black==18.4a2

LABEL name=docker-black version=dev \
      maintainer="Alex Viscreanu <aexvir@kiwi.com>"

ENTRYPOINT [ "black" ]
CMD [ "." ]
