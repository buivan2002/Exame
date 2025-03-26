FROM ruby:3.1.2
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /rails_docker_app
WORKDIR /rails_docker_app
ADD Gemfile /rails_docker_app/Gemfile
ADD Gemfile.lock /rails_docker_app/Gemfile.lock
RUN bundle install
ADD . /rails_docker_appdock