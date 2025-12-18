#!/usr/bin/env bats

# This test is run in CI using bin/gitworkflow
# Hooked with husky pre-commit

# Check branch once at the start
setup_file() {
  echo "Tests will run in temporary git repositories" >&3
}

setup() {
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  git init
  git config user.name "Test User"
  git config user.email "test@example.com"
  git checkout -b main
  echo "initial" > README.md
  git add README.md
  git commit -m "chore: initial commit"
  SCRIPT="${BATS_TEST_DIRNAME}/../bin/gitworkflow-cli.cjs"
}

teardown() {
  cd ..
  rm -rf "$TMPDIR"
}

# This test always runs to show branch status
@test "branch status check" {
  [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ]
}

@test "creates package.json" {
  run node "$SCRIPT" --yes
  [ "$status" -eq 0 ]
  [ -f package.json ]
}

# These tests only run on main branch
@test "installs husky hook" {
  [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] || skip "Skipping main-branch-only test"
  run node "$SCRIPT" --yes
  [ -f .husky/pre-commit ]
}

@test "accepts conventional commit" {
  [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] || skip "Skipping main-branch-only test"
  run node "$SCRIPT" --yes
  git add .
  git commit -m "feat: Test the integration"
}

@test "rejects non-conventional commit – missing type" {
  [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] || skip "Skipping main-branch-only test"
  run node "$SCRIPT" --yes
  echo "bad message" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "type may not be empty" ]]
}

@test "rejects non-conventional commit – missing subject" {
  [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ] || skip "Skipping main-branch-only test"
  run node "$SCRIPT" --yes
  echo "feat:" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "subject may not be empty" ]]
}