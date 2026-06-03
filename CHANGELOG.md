# Changelog

## Unreleased

- Started KeyScout as an open-source macOS unused hotkey finder.
- Added OSS repository docs, MIT license, contribution guide, security policy,
  privacy policy, support guide, code of conduct, roadmap, issue templates, PR
  template, CODEOWNERS, and labels.
- Added a local-only `project.md` working note and removed it from GitHub
  tracking.
- Added SwiftPM macOS app scaffold.
- Added native menu bar app shell.
- Added best-effort Accessibility API shortcut scan for the frontmost app.
- Added shortcut model, modifier normalization, conflict lookup, unused shortcut
  generation, and JSON import/export.
- Added unit tests for shortcut generation, conflict lookup, and JSON round
  trips.
- Added local unsigned `.app` bundle build script.
- Added GitHub Actions `Swift Build and Test` workflow.
- Added project-specific `AGENTS.md` with branch workflow and protection facts.
- Added a `Scanned Shortcuts` menu bar submenu for browsing the latest
  frontmost-app scan.
- Documented the exported JSON catalog schema and added an exact-output schema
  fixture test.
- Added an initial shortcut mapping library that can merge curated/manual
  mappings with scanned shortcuts for conflict detection.
- Expanded and documented conservative reserved shortcut defaults for unused
  shortcut generation.
- Added menu status and settings shortcut for missing Accessibility permission.
