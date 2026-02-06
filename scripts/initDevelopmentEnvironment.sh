#!/usr/bin/env sh

# Execute this file after first cloning the repository.

set -e

# REPO_ROOT is passed as the first argument, or defaults to two levels up from this script
REPO_ROOT=${1:-$(cd "$(dirname "$0")/../.." && pwd)}
cd "$REPO_ROOT" || exit 1

echo "Setting git hooks"
git config --local core.hooksPath ./toolkit/hooks
git config --local commit.template ./toolkit/resources/git-commit-msg-template.txt

# Detect existing Gradle build
if [ -f build.gradle ] || \
   [ -f build.gradle.kts ] || \
   [ -f settings.gradle ] || \
   [ -f settings.gradle.kts ]; then
  echo "✅ Gradle project already exists — skipping init"
  exit 0
fi

# Ensure Gradle is available
if ! command -v ./gradlew >/dev/null 2>&1; then
  echo "❌ Gradle not found. Please install Gradle first."
  exit 1
fi

echo "🚀 Initializing Gradle project..."
./gradlew init --project-name "$(basename "$REPO_ROOT")"

echo "✅ Gradle initialized"
