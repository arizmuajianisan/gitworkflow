#!/usr/bin/env bats

# This test is run in CI using bin/gitworkflow
# Hooked with husky pre-commit

# Check branch once at the start
IS_MAIN_BRANCH=""
setup_file() {
  if [ "$(git rev-parse --abbrev-ref HEAD)" = "main" ]; then
    IS_MAIN_BRANCH=1
  else
    IS_MAIN_BRANCH=0
    echo "Not on main branch, running only basic tests" >&3
  fi
}

setup() {
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  SCRIPT="${BATS_TEST_DIRNAME}/../bin/gitworkflow"
}

teardown() {
  cd ..
  rm -rf "$TMPDIR"
}

# This test always runs to show branch status
@test "branch status check" {
  if [ "$IS_MAIN_BRANCH" -eq 0 ]; then
    skip "Running in basic test mode (not on main branch)"
  fi
  [ true ]
}

@test "creates package.json" {
  run "$SCRIPT" --yes
  [ "$status" -eq 0 ]
  [ -f package.json ]
}

# These tests only run on main branch
@test "installs husky hook" {
  [ "$IS_MAIN_BRANCH" -eq 1 ] || skip "Skipping main-branch-only test"
  run "$SCRIPT" --yes
  [ -f .husky/pre-commit ]
}

@test "accepts conventional commit" {
  [ "$IS_MAIN_BRANCH" -eq 1 ] || skip "Skipping main-branch-only test"
  run "$SCRIPT" --yes
  git add .
  git commit -m "feat: Test the integration"
}

@test "rejects non-conventional commit – missing type" {
  [ "$IS_MAIN_BRANCH" -eq 1 ] || skip "Skipping main-branch-only test"
  run "$SCRIPT" --yes
  echo "bad message" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "type may not be empty" ]]
}

@test "rejects non-conventional commit – missing subject" {
  [ "$IS_MAIN_BRANCH" -eq 1 ] || skip "Skipping main-branch-only test"
  run "$SCRIPT" --yes
  echo "feat:" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "subject may not be empty" ]]
}