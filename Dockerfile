FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm
RUN npm install --global yarn

WORKDIR /services
COPY services/schema_registry /services/schema_registry
COPY services/auth/Gemfile /services/auth/Gemfile
COPY services/auth/Gemfile.lock /services/auth/Gemfile.lock
COPY services/tasker/Gemfile /services/tasker/Gemfile
COPY services/tasker/Gemfile.lock /services/tasker/Gemfile.lock
RUN cd /services/auth && bundle install
RUN cd /services/tasker && bundle install