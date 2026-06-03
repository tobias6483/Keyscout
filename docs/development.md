# Development

KeyScout is a native macOS Swift package.

## Requirements

- macOS 14 or newer
- Swift 6 / Xcode 26 or newer recommended

## Build

```sh
swift build
```

## Test

```sh
swift test
```

## Run

```sh
swift run KeyScout
```

KeyScout appears in the macOS menu bar as `⌘?`.

## Local App Bundle

```sh
scripts/build_app.sh
open dist/KeyScout.app
```

The local app bundle is unsigned. It is useful for manual testing of menu bar
behavior and macOS permissions, but it is not a release artifact.

## Accessibility Permission

Shortcut discovery uses macOS Accessibility APIs where possible. During manual
testing, macOS may ask for Accessibility permission so KeyScout can inspect app
menus. KeyScout should explain this permission before relying on it in a public
release.

## GitHub Workflow

KeyScout is open source. External contributors can fork the repository, push a
branch to their fork, and open a pull request against `main`.

Maintainers and project agents with write access should follow the detailed
workflow in [../AGENTS.md](../AGENTS.md). The short version is: work on a
branch, stage only relevant files, run `swift test`, use `gh` for PR creation
and merge, wait for the `Swift Build and Test` check, then squash-merge and
delete the branch. Do not commit or push directly to `main`.

Issue routing is automated by `.github/workflows/issue-triage.yml`. See
[triage.md](triage.md) for label behavior and maintainer review notes.
