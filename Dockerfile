FROM ruby:2.7.2

# For `yarn`, `node`, and `psql`
RUN apt-get update -qq && apt-get install -y \
  curl \
  build-essential \
  libpq-dev && \
  curl -sL https://deb.nodesource.com/setup_14.x | bash - && \
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
  echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
  apt-get update -qq && apt-get install -y nodejs yarn

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]