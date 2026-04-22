# action-ruff

[![Test](https://github.com/benner/action-ruff/workflows/Test/badge.svg)](https://github.com/benner/action-ruff/actions?query=workflow%3ATest)
[![reviewdog](https://github.com/benner/action-ruff/workflows/reviewdog/badge.svg)](https://github.com/benner/action-ruff/actions?query=workflow%3Areviewdog)
[![depup](https://github.com/benner/action-ruff/workflows/depup/badge.svg)](https://github.com/benner/action-ruff/actions?query=workflow%3Adepup)
[![release](https://github.com/benner/action-ruff/workflows/release/badge.svg)](https://github.com/benner/action-ruff/actions?query=workflow%3Arelease)
[![GitHub release (latest SemVer)](https://img.shields.io/github/v/release/benner/action-ruff?logo=github&sort=semver)](https://github.com/benner/action-ruff/releases)
[![action-bumpr supported](https://img.shields.io/badge/bumpr-supported-ff69b4?logo=github&link=https://github.com/haya14busa/action-bumpr)](https://github.com/haya14busa/action-bumpr)

Run [ruff](https://github.com/astral-sh/ruff) on pull requests with
[reviewdog](https://github.com/reviewdog/reviewdog) to get inline annotations
for Python linting violations.

## Usage

```yaml
name: reviewdog
on: [pull_request]
jobs:
  ruff:
    name: runner / ruff
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@11bd71901bbe5b1630ceea73d27597364c9af683 # v4.2.2
      - uses: benner/action-ruff@v1
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
```

## Inputs

| Name | Description | Default |
| ---- | ----------- | ------- |
| `github_token` | GitHub token | `${{ github.token }}` |
| `workdir` | Working directory relative to the root | `.` |
| `level` | Report level: `info`, `warning`, `error` | `error` |
| `reporter` | reviewdog reporter: `github-pr-check`, `github-check`, `github-pr-review` | `github-pr-check` |
| `filter_mode` | Filter mode: `added`, `diff_context`, `file`, `nofilter` | `added` |
| `fail_level` | Fail if issues at or above level: `none`, `any`, `info`, `warning`, `error` | `none` |
| `reviewdog_flags` | Additional reviewdog flags | `''` |
| `ruff_args` | Additional arguments passed to `ruff check` | `''` |

## Development

### Release

Bump version by merging a PR with a `bump:major`, `bump:minor`, or
`bump:patch` label.
[haya14busa/action-bumpr](https://github.com/haya14busa/action-bumpr)
handles the tag,
[haya14busa/action-update-semver](https://github.com/haya14busa/action-update-semver)
keeps `v1` / `v1.2` aliases in sync.

### Dependencies

[reviewdog/action-depup](https://github.com/reviewdog/action-depup) runs
daily to update the reviewdog version in the Dockerfile and open a PR.
