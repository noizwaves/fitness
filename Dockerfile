FROM ruby:2.7.3 as base

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


FROM base as gems
COPY Gemfile Gemfile.lock /app/
RUN --mount=type=cache,target=/tmp/.bundle_cache \
  bundle config set path /tmp/.bundle_cache && \
  bundle install && \
  cp -ar /tmp/.bundle_cache/ruby/2.7.0/** /usr/local/bundle && \
  bundle config unset path


FROM base as node_modules
COPY package.json yarn.lock /app/
RUN --mount=type=cache,target=/tmp/.yarn_cache \
  mkdir -p /usr/local/share/.cache/yarn && \
  yarn install --cache-folder /tmp/.yarn_cache && \
  cp -ar /tmp/.yarn_cache/v6 /usr/local/share/.cache/yarn/


FROM base as final
RUN echo "if [[ -f /app/.aliases ]]; then" >> /root/.bashrc && \
    echo "  . /app/.aliases" >> /root/.bashrc && \
    echo "fi" >> /root/.bashrc

COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY --from=node_modules /app/node_modules /app/node_modules
COPY --from=node_modules /usr/local/share/.cache/yarn/v6 /usr/local/share/.cache/yarn/v6

COPY . /app

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]