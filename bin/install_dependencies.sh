#!/usr/bin/env bash

LOG_PATH=/proc/1/fd/1

GEMFILE_SHA=$(sha256sum /app/Gemfile | cut -d ' ' -f 1)
GEMFILE_TOUCH_PATH=/tmp/${GEMFILE_SHA}
if [ ! -f "$GEMFILE_TOUCH_PATH" ]; then
  {
    printf "## Running bundle install\n"
    bundle install
    printf "## Finished bundle install\n"
  } >> $LOG_PATH
  touch "$GEMFILE_TOUCH_PATH"
fi

YARN_SHA=$(sha256sum /app/package.json | cut -d ' ' -f 1)
YARN_TOUCH_PATH=/tmp/${YARN_SHA}
if [ ! -f "$YARN_TOUCH_PATH" ]; then
  {
    printf "## Running yarn install\n"
    yarn install
    printf "## Finished yarn install\n"
  } >> $LOG_PATH
  touch "$YARN_TOUCH_PATH"
fi