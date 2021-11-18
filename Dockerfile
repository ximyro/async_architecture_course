FROM ruby:2.7
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client npm cron
RUN npm install --global yarn

WORKDIR /services
COPY services/schema_registry /services/schema_registry
COPY services/auth/Gemfile /services/auth/Gemfile
COPY services/auth/Gemfile.lock /services/auth/Gemfile.lock
COPY services/tasker/Gemfile /services/tasker/Gemfile
COPY services/tasker/Gemfile.lock /services/tasker/Gemfile.lock
COPY services/accounting/Gemfile /services/accounting/Gemfile
COPY services/accounting/Gemfile.lock /services/accounting/Gemfile.lock
COPY services/analytics/Gemfile /services/analytics/Gemfile
COPY services/analytics/Gemfile.lock /services/analytics/Gemfile.lock
RUN cd /services/auth && bundle install
RUN cd /services/tasker && bundle install
RUN cd /services/accounting && bundle install
RUN cd /services/analytics && bundle install