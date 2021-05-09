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

RUN groupadd --gid 1000 -r fitness && useradd --uid 1000 --no-log-init -r -m -g fitness fitness
USER fitness

ARG RAILS_ENV=development
ENV RAILS_ENV=${RAILS_ENV}

WORKDIR /home/fitness/app


FROM base as gems
COPY --chown=fitness:fitness Gemfile Gemfile.lock /home/fitness/app/
RUN --mount=type=cache,target=/tmp/.bundle_cache,uid=1000,gid=1000 \
  bundle config set path /tmp/.bundle_cache && \
  bundle install && \
  cp -ar /tmp/.bundle_cache/ruby/2.7.0/** /usr/local/bundle && \
  bundle config unset path


FROM base as node_modules
COPY --chown=fitness:fitness package.json yarn.lock .npmrc .yarnrc /home/fitness/app/
RUN --mount=type=cache,target=/tmp/.yarn_cache,uid=1000,gid=1000 \
  mkdir -p /home/fitness/.cache/yarn && \
  yarn install --cache-folder /tmp/.yarn_cache && \
  cp -ar /tmp/.yarn_cache/v6 /home/fitness/.cache/yarn/


FROM base as final
COPY --from=gems /usr/local/bundle /usr/local/bundle
COPY --from=node_modules /home/fitness/node_modules /home/fitness/node_modules
COPY --from=node_modules /home/fitness/.cache/yarn/v6 /home/fitness/.cache/yarn/v6

COPY --chown=fitness:fitness . /home/fitness/app

# Add a script to be executed every time the container starts.
RUN chmod +x entrypoint.sh
ENTRYPOINT ["/home/fitness/app/entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]