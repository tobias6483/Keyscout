# Requirements

This document tracks implementation coverage against the product brief.

## MVP Coverage

- Menu bar app: initial Swift/AppKit status item scaffold
- Global hotkey scanner: not implemented yet
- Known shortcuts per app: initial accessibility-based frontmost app scan with
  menu submenu browsing, searchable list window, source filtering, selected-row
  conflict details, and built-in curated mapping merge
- Generate unused shortcut: initial deterministic generator implemented
- Reserved shortcut handling: expanded conservative defaults documented
- Conflict warning: core conflict lookup and selected-row conflict detail
  implemented
- Export to JSON: initial export of latest scan to Downloads with documented
  catalog schema
- Import mapping JSON: local persistent import and scan merge
- Accessibility permission UX: initial menu status and settings shortcut
- Local-only, no tracking: preserved
- Issue triage and privacy review: implemented for OSS maintainer routing
- Unsigned app artifact workflow: implemented for maintainer QA, not public release distribution

## Current Limitations

- Accessibility scanning is best-effort and currently scans the frontmost app.
- Accessibility settings still require the user to enable KeyScout manually in
  macOS System Settings.
- Global hotkeys registered outside app menus are not detected yet.
- Built-in curated mappings are intentionally minimal.
- Reserved shortcut defaults are conservative and not OS-version-aware yet.
- The shortcut list window is still a compact MVP table and does not yet support
  checking arbitrary typed shortcuts.
