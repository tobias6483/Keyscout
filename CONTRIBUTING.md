# Contributing to KeyScout

Thanks for helping build KeyScout. This project is intended to be a small, native, privacy-first macOS utility for people who care about keyboard workflows.

## Project Stage

KeyScout is currently in early planning. Good contributions at this stage include:

- Product feedback on the MVP and open questions
- Research into macOS Accessibility APIs and shortcut discovery
- Shortcut mapping examples for real macOS apps
- Test cases for shortcut parsing and conflict detection
- Documentation improvements
- SwiftUI/macOS implementation proposals

## Development Principles

- Keep the app local-only by default.
- Do not add tracking, telemetry, or account requirements.
- Prefer native macOS APIs and SwiftUI.
- Keep UI flows small and menu bar-friendly.
- Explain limitations clearly, especially around shortcuts that cannot be detected automatically.
- Keep shortcut data inspectable and exportable.

## Getting Started

KeyScout is a Swift package. To build and test locally:

```sh
swift build
swift test
```

To run the menu bar app:

```sh
swift run KeyScout
```

To build a local unsigned app bundle:

```sh
scripts/build_app.sh
```

## Pull Requests

Before opening a pull request:

- Keep the change focused.
- Update docs when behavior or project direction changes.
- Add or update tests for parsing, normalization, generation, or conflict logic when relevant.
- Avoid unrelated formatting churn.
- Do not include secrets, local config, generated personal files, or private shortcut data.

Pull requests should describe:

- What changed
- Why it changed
- How it was tested
- Known limitations or follow-up work
- Whether it changes privacy, permissions, local storage, exports, or release behavior

## Issues

When filing an issue, include enough detail to reproduce or understand it:

- macOS version
- App name and version, if the issue is app-specific
- Shortcut combination involved
- Whether the shortcut came from automatic discovery, curated data, or manual input
- Screenshots or logs when useful, with private data removed

## Shortcut Mapping Contributions

Shortcut data is expected to be imperfect. If you contribute mappings:

- Include the app name and version.
- Prefer stable menu item names.
- Note whether the mapping was detected, manually verified, or imported.
- Follow the exported catalog shape in
  [docs/json-schema.md](docs/json-schema.md).
- Expect mappings to be matched by app name or bundle identifier.
- Avoid adding private, organization-specific, or personally identifying shortcut data.

## Issue Triage

New and edited issues are labeled automatically by GitHub Actions based on the
issue title/body and issue-form fields. See [docs/triage.md](docs/triage.md)
for the current label set and privacy-review signals.

Permission-sensitive proposals should use the `Privacy review` issue template
before implementation.

## Code of Conduct

All contributors are expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
