FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install --global yarn

WORKDIR /services
COPY services/auth/Gemfile /services/auth/Gemfile
COPY services/auth/Gemfile.lock /services/auth/Gemfile.lock
RUN cd /services/auth && bundle install