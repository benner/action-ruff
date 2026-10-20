#!/usr/bin/env bash
set -euo pipefail

cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}"

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

ruff --version

RUFF_OUTPUT="$(mktemp)"

set +e
# shellcheck disable=SC2086
ruff check --output-format=concise ${INPUT_RUFF_ARGS} . >"${RUFF_OUTPUT}"
RUFF_EXIT_CODE=$?
set -e

if [ "${RUFF_EXIT_CODE}" -gt 1 ]; then
    exit "${RUFF_EXIT_CODE}"
fi

# shellcheck disable=SC2086
reviewdog -efm="%f:%l:%c: %m" \
    -name="ruff" \
    -reporter="${INPUT_REPORTER}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-level="${INPUT_FAIL_LEVEL}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS} <"${RUFF_OUTPUT}"
