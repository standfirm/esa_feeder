FROM ruby:2.5.3-alpine3.9

RUN apk update && apk add g++ git make

RUN mkdir /app
COPY Gemfile Gemfile.lock .ruby-version esa_feeder.gemspec /app/
RUN mkdir -p /app/lib/esa_feeder
COPY lib/esa_feeder/version.rb /app/lib/esa_feeder/

WORKDIR /app
RUN bundle install

VOLUME /app
CMD ["/bin/sh"]
