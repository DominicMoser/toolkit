#!/bin/sh
set -e
echo "Running ci-release script"
echo "Marking directory as safe"
git config --global --add safe.directory "$(pwd)"
REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"
echo "🔧 Bootstrapping CI environment (Alpine)"
# --- Base packages ---
apk add --no-cache \
  bash \
  curl \
  git \
  openssh \
  ca-certificates

# --- Java (bootstrap JVM for Gradle) ---
if ! command -v java >/dev/null 2>&1; then
  echo "☕ Installing OpenJDK (bootstrap)"
  apk add --no-cache openjdk25-jre openjdk25-jdk

fi

# --- Node.js (semantic-release) ---
if ! command -v node >/dev/null 2>&1; then
  echo "🟢 Installing Node.js"
  apk add --no-cache nodejs npm
fi

# --- Install toolkit dependencies ---
echo "📦 Installing toolkit dependencies"
cd toolkit
npm ci
cd ..

# --- Run semantic-release ---
echo "🚀 Running semantic-release"
NODE_PATH="$REPO_ROOT/toolkit/node_modules" \
  node "$REPO_ROOT/toolkit/node_modules/.bin/semantic-release"
