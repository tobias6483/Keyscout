# Requirements

This document tracks implementation coverage against the product brief.

## MVP Coverage

- Menu bar app: initial Swift/AppKit status item scaffold
- Global hotkey scanner: not implemented yet
- Known shortcuts per app: initial accessibility-based frontmost app scan
- Generate unused shortcut: initial deterministic generator implemented
- Conflict warning: core conflict lookup implemented
- Export to JSON: initial export of latest scan to Downloads
- Local-only, no tracking: preserved
- Issue triage and privacy review: implemented for OSS maintainer routing
- Unsigned app artifact workflow: implemented for maintainer QA, not public release distribution

## Current Limitations

- Accessibility scanning is best-effort and currently scans the frontmost app.
- Global hotkeys registered outside app menus are not detected yet.
- Curated shortcut mappings are not implemented yet.
- JSON schema is generated from Swift Codable models and still needs a stable
  documented schema before external contributors add mappings.
- The menu bar UI is intentionally minimal and needs a richer shortcut list view.
