FROM ruby:2.4

ENV PACKAGES="git-core curl zlib1g-dev libv8-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev libcurl4-openssl-dev python-software-properties libffi-dev"

RUN apt-get update
RUN apt-get install -y $PACKAGES
RUN gem install bundler

ENV APP_HOME /splits_engine

RUN mkdir $APP_HOME

WORKDIR $APP_HOME

ADD Gemfile* $APP_HOME/

VOLUME $APP_HOME/public

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
  BUNDLE_JOBS=2

ADD . $APP_HOME

RUN bundle install --retry 5

CMD bundle exec rails server -p 4242

EXPOSE 4242
