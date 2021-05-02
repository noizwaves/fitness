#!/usr/bin/env bash
set -e

# Remove a potentially pre-existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Start Visual Studio Code
code-server &

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
