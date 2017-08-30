FROM ruby:2.4.1-alpine

RUN apk add --update --no-cache build-base tzdata libxml2-dev libxslt-dev postgresql-dev
ENV dir /usr/src/app

RUN mkdir -p ${dir}
WORKDIR ${dir}

COPY . ${dir}

RUN gem install bundler && bundle install -j4
RUN gem cleanup
