# Known Limitations

KeyScout is an early MVP. It is useful for inspecting app-menu shortcuts, but it
does not yet have complete system-wide shortcut awareness.

## Accessibility Scanning

Current scanning:

- Reads the frontmost app's menu bar through macOS Accessibility APIs.
- Captures menu item shortcuts when the app exposes command character and
  modifier attributes.
- Preserves app name, bundle identifier, menu path, shortcut, and source.
- Merges matching built-in or imported mappings by app name or bundle
  identifier.

Known scanning gaps:

- Only the frontmost app is scanned.
- Apps may omit shortcuts from Accessibility attributes.
- Contextual commands, toolbar buttons, custom controls, web-app shortcuts, and
  command palettes may not appear in the menu tree.
- Global hotkeys registered by launchers, automation tools, background agents,
  or system services are not detected yet.
- System Settings shortcuts and user-customized keyboard shortcuts are not
  read directly yet.
- Permission is user-controlled. KeyScout can open Accessibility settings, but
  the user must enable access manually.

## Imported Mappings

Current import behavior:

- Imports KeyScout catalog JSON files.
- Keeps imported data local and in memory for the current app session.
- Merges imported shortcuts with future scans when app name or bundle identifier
  matches.

Known import gaps:

- Imported mappings are not persisted across launches yet.
- There is no mapping validation UI beyond JSON decode errors.
- There is no schema version field yet.
- Duplicate and conflicting external mapping review is still minimal.

## Shortcut Suggestions

Current suggestion behavior:

- Uses deterministic candidate keys and modifier sets.
- Skips known scanned/imported conflicts.
- Skips conservative default reserved shortcuts.

Known suggestion gaps:

- Suggestions are not ranked by user preference or app context yet.
- Reserved shortcuts are not OS-version-aware yet.
- User-defined blocked combinations are not implemented yet.
- Suggestions cannot account for global shortcuts KeyScout cannot detect.

## UI And Release Status

- The shortcut list window supports search and source filtering, but it is still
  a compact MVP table.
- Builds are unsigned and not notarized unless release automation changes.
- Manual QA against real apps and permission states is still required before a
  public v0.1 release.
