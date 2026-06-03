# Requirements

This document tracks implementation coverage against the product brief.

## MVP Coverage

- Menu bar app: initial Swift/AppKit status item scaffold
- Global hotkey scanner: not implemented yet
- Known shortcuts per app: initial accessibility-based frontmost app scan with
  menu submenu browsing and built-in curated mapping merge
- Generate unused shortcut: initial deterministic generator implemented
- Reserved shortcut handling: expanded conservative defaults documented
- Conflict warning: core conflict lookup implemented
- Export to JSON: initial export of latest scan to Downloads with documented
  catalog schema
- Accessibility permission UX: initial menu status and settings shortcut
- Local-only, no tracking: preserved
- Issue triage and privacy review: implemented for OSS maintainer routing
- Unsigned app artifact workflow: implemented for maintainer QA, not public release distribution

## Current Limitations

- Accessibility scanning is best-effort and currently scans the frontmost app.
- Accessibility settings still require the user to enable KeyScout manually in
  macOS System Settings.
- Global hotkeys registered outside app menus are not detected yet.
- External curated/manual shortcut mapping import is not implemented yet.
- Built-in curated mappings are intentionally minimal.
- Reserved shortcut defaults are conservative and not OS-version-aware yet.
- The menu bar UI can show a limited shortcut submenu, but still needs a richer
  shortcut list view for searching and inspecting full scans.
