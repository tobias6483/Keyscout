# Changelog

## Unreleased

No unreleased changes yet.

## v0.1.1-alpha - 2026-06-04

- Clarified install, run-mode, and Accessibility permission identity guidance
  for release testers and contributors.
- Added a more specific missing Accessibility permission message and a
  `Reveal KeyScout in Finder` menu action.
- Added Developer ID signing and notarization-capable packaging scripts and
  GitHub artifact workflow configuration.
- Documented that GitHub Actions release secrets are private and should only be
  exposed to trusted release workflows.

## v0.1.0-alpha - 2026-06-04

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
- Added local ad-hoc signed `.app` bundle build script.
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
- Added a native shortcut list window with search and source filtering.
- Added selected-row conflict details to the shortcut list window.
- Added JSON import for curated/manual shortcut mappings.
- Added a known limitations page for Accessibility scanning, imports,
  suggestions, UI, and release status.
- Added persistent local storage for imported curated/manual shortcut mappings.
- Added ad-hoc signed app packaging with SHA-256 checksum generation for v0.1
  release preparation.
- Fixed the menu bar `Quit` action so it is enabled and terminates KeyScout.
- Recorded a v0.1 manual QA pass for launch, menu status, missing Accessibility
  permission behavior, shortcut list opening, JSON export, JSON import, invalid
  import errors, and local-only behavior.
