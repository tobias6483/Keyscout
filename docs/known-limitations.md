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
- Accessibility permission is bound to the exact app identity macOS sees.
  Release testers should grant permission to the downloaded and unzipped
  `KeyScout.app`; contributors should grant permission to
  `/Users/tobias/Documents/Development/Keyscout/dist/KeyScout.app`.
- `swift run KeyScout` launches a different SwiftPM debug executable and is not
  the supported mode for Accessibility scanning. It does not share
  Accessibility permission with `KeyScout.app`.
- Rebuilt or moved local app bundles may need to be removed and re-added in
  Accessibility settings.

## Imported Mappings

Current import behavior:

- Imports KeyScout catalog JSON files.
- Keeps imported data local in
  `~/Library/Application Support/KeyScout/imported-mappings.json`.
- Merges imported shortcuts with future scans when app name or bundle identifier
  matches.

Known import gaps:

- Imported mappings do not appear in the list immediately after import unless
  they match the latest scanned app name or bundle identifier.
- There is no mapping validation UI beyond JSON decode errors.
- There is no schema version field yet.
- Duplicate and conflicting external mapping review is still minimal.

## Shortcut Suggestions

Current suggestion behavior:

- Uses deterministic candidate keys and modifier sets.
- Skips known scanned/imported conflicts.
- Skips conservative default reserved shortcuts.

Known suggestion gaps:

- `Generate Unused Shortcut` scans the current frontmost context before
  suggesting. If KeyScout's own shortcut list window is frontmost, the latest
  app catalog can be replaced with an empty/non-useful scan.
- Suggestions are not ranked by user preference or app context yet.
- Reserved shortcuts are not OS-version-aware yet.
- User-defined blocked combinations are not implemented yet.
- Suggestions cannot account for global shortcuts KeyScout cannot detect.

## UI And Release Status

- The shortcut list window supports search and source filtering, but it is still
  a compact MVP table.
- Conflict detail is driven by selecting an existing row; there is no arbitrary
  shortcut input/parser yet.
- Local development builds are ad-hoc signed by default. The release pipeline
  can produce Developer ID signed, notarized artifacts once maintainer
  certificate and notary secrets are configured.
- The published v0.1.0-alpha artifact remains ad-hoc signed and not notarized.
- Manual QA has covered the missing Accessibility permission path, successful
  Finder and Safari Accessibility scans, JSON import/export, persistent import
  storage, search/source filtering, and selected-row conflict detail.
