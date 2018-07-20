FROM ruby:2-alpine

RUN apk update && apk add \
      alpine-sdk \
      gettext

WORKDIR /usr/src/app
COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install --without test

COPY lib/ /usr/src/app/

CMD thin -R config.ru start
