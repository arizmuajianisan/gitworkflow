#!/usr/bin/env bats

# This test is run in CI using bin/gitworkflow
# Hooked with husky pre-commit

setup() {
  TMPDIR=$(mktemp -d)
  cd "$TMPDIR"
  SCRIPT="${BATS_TEST_DIRNAME}/../bin/gitworkflow"
}

teardown() {
  cd ..
  rm -rf "$TMPDIR"
}

@test "creates package.json" {
  run "$SCRIPT" --yes
  [ "$status" -eq 0 ]
  [ -f package.json ]
}

@test "installs husky hook" {
  run "$SCRIPT" --yes
  [ -f .husky/pre-commit ]
}

@test "accepts conventional commit" {
  run "$SCRIPT" --yes
  git add .
  git commit -m "feat: Test the integration"
}

@test "rejects non-conventional commit – missing type" {
  run "$SCRIPT" --yes
  echo "bad message" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "type may not be empty" ]]
}

@test "rejects non-conventional commit – missing subject" {
  run "$SCRIPT" --yes
  echo "feat:" > tmp.msg
  run npx --no-install commitlint --config commitlint.config.js --edit tmp.msg
  [ "$status" -ne 0 ]
  [[ "$output" =~ "subject may not be empty" ]]
}