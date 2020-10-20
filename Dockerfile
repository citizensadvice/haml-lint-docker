FROM ruby:2.7-alpine as build

ENV BUNDLER_VERSION 2.1.4

RUN apk add --no-cache --update build-base git

ADD Gemfile* /haml-lint/
WORKDIR /haml-lint

ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=6 \
    BUNDLE_RETRY=3

RUN gem update --system && gem install bundler && bundle install && gem cleanup

FROM ruby:2.7-alpine as haml-lint

WORKDIR /haml-lint
ADD ./ /haml-lint

COPY --from=build /usr/local /usr/local

CMD bundle exec haml-lint /app/app/views
