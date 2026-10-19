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
    permissions:
      contents: read
      pull-requests: write
    steps:
      - uses: actions/checkout@9c091bb21b7c1c1d1991bb908d89e4e9dddfe3e0  # v7.0.0
      - uses: benner/action-ruff@v0.3.0
        with:
          github_token: ${{ secrets.github_token }}
          reporter: github-pr-review
          level: warning
```

The `github-pr-check` and `github-check` reporters need `checks: write`
instead of `pull-requests: write`.

The action is a composite action: it installs reviewdog with
[reviewdog/action-setup](https://github.com/reviewdog/action-setup) and ruff
with [astral-sh/ruff-action](https://github.com/astral-sh/ruff-action), so it
runs on any GitHub-hosted runner without building a container image.

ruff-action exports `RUFF_OUTPUT_FORMAT=github` into the job environment.
Later `ruff` steps in the same job print GitHub workflow commands unless
they pass their own `--output-format`.

## Inputs

| Name | Description | Default |
| ---- | ----------- | ------- |
| `github_token` | GitHub token | `${{ github.token }}` |
| `workdir` | Working directory relative to the root | `.` |
| `ruff_version` | ruff version to install; empty uses the version pinned in the project's `pyproject.toml`, `requirements.txt` or `uv.lock`, else latest | `''` |
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
daily to update the reviewdog version in `action.yml` and open a PR. The
ruff version follows the project being linted, so it needs no bump here.
