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

The app implementation has not started yet. Once the Swift project is scaffolded, this section should include:

```sh
swift test
```

and any required Xcode or Swift Package Manager setup.

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
- Avoid adding private, organization-specific, or personally identifying shortcut data.

## Code of Conduct

All contributors are expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md).
