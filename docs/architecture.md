# Architecture

KeyScout is starting with a small native macOS architecture.

## App Shell

- `AppDelegate` owns the menu bar status item and menu actions.
- `ShortcutListWindowController` owns the searchable native shortcut list
  window and selected-row conflict detail.
- `KeyScoutController` coordinates scanning, shortcut generation, conflict
  lookup, Accessibility permission status, JSON import, and JSON export.

## Core Model

- `KeyboardShortcut` normalizes key labels and modifier ordering.
- `ShortcutModifiers` represents command, shift, option, and control.
- `AppShortcut` represents one shortcut discovered or contributed for an app.
- `ShortcutCatalog` stores scanned shortcuts and answers conflict queries.
- `ShortcutMappingLibrary` filters curated/manual mappings for the scanned app
  and merges them into the latest catalog.
- `ShortcutMappingStore` persists imported curated/manual mappings as local
  catalog JSON in Application Support.
- `ShortcutGenerator` searches deterministic candidate combinations and skips
  known conflicts and reserved shortcuts.
- `ReservedShortcutDefaults` groups conservative default reservations for
  common app lifecycle, system UI, and editing shortcuts.
- `ShortcutJSONStore` imports and exports catalog JSON documented in
  [json-schema.md](json-schema.md).
- `ShortcutListPresenter` formats scanned shortcuts for compact menu display.
  It also prepares filterable rows and conflict detail text for the shortcut
  list window.

## Scanning

`AccessibilityShortcutScanner` uses macOS Accessibility APIs to inspect the
frontmost application's menu bar. This is intentionally best-effort because not
all shortcuts are exposed reliably by apps or the OS.

`KeyScoutController` checks Accessibility trust before scan or generation
actions. `AppDelegate` shows the permission status in the menu and can open the
macOS Accessibility settings pane.

Imported mapping JSON is decoded with `ShortcutJSONStore`, merged into the
controller's imported `ShortcutMappingLibrary`, persisted with
`ShortcutMappingStore`, and merged with scans by app name or bundle identifier.
Built-in mappings remain separate from imported mappings.

Future scanner work should separate:

- app menu shortcut discovery
- bundled and imported curated app mapping data
- user-imported/manual global hotkey data
- reserved macOS system shortcuts
