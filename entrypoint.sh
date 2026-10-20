#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
    cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
    git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

RUFF_OUTPUT="$(mktemp)"

set +e
# shellcheck disable=2086
/root/.local/bin/ruff check --output-format=concise ${INPUT_RUFF_ARGS} . >"${RUFF_OUTPUT}"
RUFF_EXIT_CODE=$?
set -e

if [ "${RUFF_EXIT_CODE}" -gt 1 ]; then
    exit "${RUFF_EXIT_CODE}"
fi

# shellcheck disable=2086
reviewdog -efm="%f:%l:%c: %m" \
    -name="ruff" \
    -reporter="${INPUT_REPORTER:-github-pr-check}" \
    -filter-mode="${INPUT_FILTER_MODE}" \
    -fail-level="${INPUT_FAIL_LEVEL}" \
    -level="${INPUT_LEVEL}" \
    ${INPUT_REVIEWDOG_FLAGS} <"${RUFF_OUTPUT}"
