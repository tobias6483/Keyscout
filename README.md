# KeyScout

Unused hotkey finder for macOS.

KeyScout is an open-source macOS menu bar app that helps you find unused keyboard shortcuts before you assign new hotkeys. The goal is simple: scan known shortcuts across your active apps, warn about conflicts, and suggest combinations that are likely to be free.

## MVP Status

KeyScout is in early MVP development.

Implemented:

- Native Swift/AppKit menu bar scaffold
- Best-effort frontmost app shortcut scan through macOS Accessibility APIs
- Menu status for missing Accessibility permission with settings shortcut
- Scanned shortcut submenu for browsing the latest frontmost-app scan
- Native shortcut list window with search, source filtering, and selected-row
  conflict details
- Built-in curated shortcut mapping library for supplementing scans
- JSON import for curated/manual shortcut mappings
- Persistent local storage for imported curated/manual mappings
- Deterministic unused shortcut generator
- Conservative reserved shortcut defaults for common macOS/app combinations
- Shortcut conflict lookup
- JSON export for the latest shortcut catalog with documented schema and sample
- Unit tests for shortcut generation, conflict lookup, and JSON round trips
- GitHub Actions build and test workflow
- GitHub issue triage and unsigned app artifact workflows

Planned:

- Global hotkey detection beyond app menus
- Signed app release workflow

## MVP

- Menu bar app
- Global hotkey scanner
- List of known shortcuts per app
- Generate unused shortcut
- Conflict warning, for example: `⌘⇧K is already used by VS Code`
- Export shortcut data to JSON
- Local-only behavior with no tracking

## Principles

- Native macOS utility, not a web wrapper
- Privacy-first: shortcut analysis stays local
- Fast menu bar workflow
- Clear conflict explanations
- Open shortcut data model
- No account creation, analytics, or telemetry

## Technical Direction

- Swift/AppKit for the current menu bar app shell, with SwiftUI still available
  for richer future views
- macOS Accessibility APIs where shortcuts can be discovered reliably
- Curated shortcut mapping data where apps cannot expose everything
- JSON import/export for mappings and user snapshots
- Tests for shortcut parsing, normalization, conflict detection, and generation

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

The local app bundle is unsigned. See [docs/development.md](docs/development.md).

## Repository

- [CONTRIBUTING.md](CONTRIBUTING.md) explains how to contribute.
- [SECURITY.md](SECURITY.md) explains how to report security issues.
- [PRIVACY.md](PRIVACY.md) documents the privacy model.
- [ROADMAP.md](ROADMAP.md) tracks planned milestones.
- [CHANGELOG.md](CHANGELOG.md) tracks unreleased and released changes.
- [docs/requirements.md](docs/requirements.md) tracks MVP coverage.
- [docs/architecture.md](docs/architecture.md) explains the current code shape.
- [docs/development.md](docs/development.md) explains local development.
- [docs/known-limitations.md](docs/known-limitations.md) explains current
  scanning, import, suggestion, and release limitations.
- [docs/json-schema.md](docs/json-schema.md) documents exported shortcut
  catalogs.
- [docs/reserved-shortcuts.md](docs/reserved-shortcuts.md) documents default
  reserved shortcut handling.
- [docs/release.md](docs/release.md) explains release and artifact status.
- [docs/triage.md](docs/triage.md) explains issue labels and automation.

## License

KeyScout is released under the [MIT License](LICENSE).
