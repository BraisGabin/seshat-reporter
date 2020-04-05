#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -ex

cd "${GITHUB_WORKSPACE}"

diff_file=$(mktemp)
git diff >${diff_file}

git log >asdf
cat asdf

pull_number=$(jq --raw-output .pull_request.number "${GITHUB_EVENT_PATH}")
curl --data-binary "@${diff_file}" \
  -H "Content-Type: text/plain" \
  -X POST \
  "https://seshat-style.herokuapp.com/github/${GITHUB_REPOSITORY}/pulls/${pull_number}/${GITHUB_SHA}"
