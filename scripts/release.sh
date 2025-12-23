#!/bin/sh
set -e

REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT"

# Ensure toolkit deps are installed
cd toolkit
npm install --no-fund --no-audit
cd ..

# Run semantic-release using toolkit's node_modules
NODE_PATH="$REPO_ROOT/toolkit/node_modules" \
  node "$REPO_ROOT/toolkit/node_modules/.bin/semantic-release" "$@"
