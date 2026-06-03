# KeyScout

Unused hotkey finder for macOS.

KeyScout is an open-source macOS menu bar app that helps you find unused keyboard shortcuts before you assign new hotkeys. The goal is simple: scan known shortcuts across your active apps, warn about conflicts, and suggest combinations that are likely to be free.

## Status

KeyScout is in early planning. The repository currently contains the product brief, contribution guidelines, and project policies. The macOS app implementation has not started yet.

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

- Swift and SwiftUI for the macOS app shell
- macOS Accessibility APIs where shortcuts can be discovered reliably
- Curated shortcut mapping data where apps cannot expose everything
- JSON import/export for mappings and user snapshots
- Tests for shortcut parsing, normalization, conflict detection, and generation

## Repository

- [project.md](project.md) contains the product brief and open questions.
- [CONTRIBUTING.md](CONTRIBUTING.md) explains how to contribute.
- [SECURITY.md](SECURITY.md) explains how to report security issues.
- [PRIVACY.md](PRIVACY.md) documents the privacy model.
- [ROADMAP.md](ROADMAP.md) tracks planned milestones.

## License

KeyScout is released under the [MIT License](LICENSE).
