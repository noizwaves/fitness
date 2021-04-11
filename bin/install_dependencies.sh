#!/usr/bin/env bash

GEMFILE_SHA=$(sha256sum /app/Gemfile | cut -d ' ' -f 1)
GEMFILE_TOUCH_PATH=/tmp/${GEMFILE_SHA}
if [ ! -f ${GEMFILE_TOUCH_PATH} ]; then
  bundle install
  touch ${GEMFILE_TOUCH_PATH}
fi

YARN_SHA=$(sha256sum /app/package.json | cut -d ' ' -f 1)
YARN_TOUCH_PATH=/tmp/${YARN_SHA}
if [ ! -f ${YARN_TOUCH_PATH} ]; then
  yarn install
  touch ${YARN_TOUCH_PATH}
fi