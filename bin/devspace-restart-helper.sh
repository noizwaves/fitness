#!/bin/sh
#
# A process wrapper script to simulate a container restart. This file was injected with devspace during the build process
#
set -e
set -m
pid=""
trap quit TERM INT
quit() {
  if [ -n "$pid" ]; then
    kill $pid
  fi
}
while true; do
  "$@" &
  pid=$!
  echo "$pid" > /.devspace/devspace-pid
  set +e
  fg
  exit_code=$?
  if [ -f /.devspace/terminated ]; then
    printf "\n\n############### Pod terminating, exiting ###############\n\nn"
    exit 0
  elif [ -f /.devspace/devspace-pid ]; then
    rm -f /.devspace/devspace-pid
    printf "\nContainer exited with $exit_code. Will restart in 7 seconds...\n"
    sleep 7
  fi
  set -e
  printf "\n\n############### Restart container ###############\n\n"
done