#!/usr/bin/env bash

# Exit immediately on non-zero return codes.
set -ex

cd "${GITHUB_WORKSPACE}"

diff_file=$(mktemp)

git diff >${diff_file}

sha=$((git show -s --pretty=format:%B | sed -E 's/^Merge ([0-9abcdef]{40}) into [0-9abcedef]{40}$/\1/; t; q1' || echo ${GITHUB_SHA}) | tail -n1)
pull_number=$(jq --raw-output .pull_request.number "${GITHUB_EVENT_PATH}")

curl --data-binary "@${diff_file}" \
	--show-error \
	--fail \
	-H "Content-Type: text/plain" \
	-X POST \
	"https://seshat-style.herokuapp.com/github/${GITHUB_REPOSITORY}/pulls/${pull_number}/${sha}"
