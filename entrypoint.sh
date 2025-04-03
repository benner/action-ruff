#!/bin/sh
set -e

if [ -n "${GITHUB_WORKSPACE}" ]; then
	cd "${GITHUB_WORKSPACE}/${INPUT_WORKDIR}" || exit
	git config --global --add safe.directory "${GITHUB_WORKSPACE}" || exit 1
fi

export REVIEWDOG_GITHUB_API_TOKEN="${INPUT_GITHUB_TOKEN}"

# shellcheck disable=2086
ruff check --output-format=concise . |
	reviewdog -efm="%f:%l:%c: %m" \
		-name="linter-name (ruff)" \
		-reporter="${INPUT_REPORTER:-github-pr-check}" \
		-filter-mode="${INPUT_FILTER_MODE}" \
		-fail-level="${INPUT_FAIL_LEVEL}" \
		-level="${INPUT_LEVEL}" \
		${INPUT_REVIEWDOG_FLAGS}
