# Dockerfile

FROM ruby:2.4.2

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev libsqlite3-dev

ENV INSTALL_PATH /opt/app/seek-assessment
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
RUN bundle install

COPY . .

RUN bundle exec rake db:create
RUN bundle exec rake db:migrate

CMD bundle exec rspec --format documentation