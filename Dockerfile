FROM ruby:2.4-alpine

ENV APP_HOME /app

RUN echo "@edge http://nl.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories &&\
    apk add --update sqlite@edge sqlite-dev@edge openssl-dev g++ musl-dev make

RUN gem install bundler

WORKDIR $APP_HOME

ENV PORT 4242

COPY ./ $APP_HOME/
ADD Gemfile $APP_HOME/

RUN bundle install --without dev test

VOLUME /uploads
VOLUME /config

CMD bundle exec rackup config.ru -s thin -p $PORT -o '0.0.0.0'

EXPOSE $PORT
