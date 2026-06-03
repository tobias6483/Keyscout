# Architecture

KeyScout is starting with a small native macOS architecture.

## App Shell

- `AppDelegate` owns the menu bar status item and menu actions.
- `KeyScoutController` coordinates scanning, shortcut generation, conflict
  lookup, and JSON export.

## Core Model

- `KeyboardShortcut` normalizes key labels and modifier ordering.
- `ShortcutModifiers` represents command, shift, option, and control.
- `AppShortcut` represents one shortcut discovered or contributed for an app.
- `ShortcutCatalog` stores scanned shortcuts and answers conflict queries.
- `ShortcutMappingLibrary` filters curated/manual mappings for the scanned app
  and merges them into the latest catalog.
- `ShortcutGenerator` searches deterministic candidate combinations and skips
  known conflicts and reserved shortcuts.
- `ReservedShortcutDefaults` groups conservative default reservations for
  common app lifecycle, system UI, and editing shortcuts.
- `ShortcutJSONStore` imports and exports catalog JSON documented in
  [json-schema.md](json-schema.md).
- `ShortcutListPresenter` formats scanned shortcuts for compact menu display.

## Scanning

`AccessibilityShortcutScanner` uses macOS Accessibility APIs to inspect the
frontmost application's menu bar. This is intentionally best-effort because not
all shortcuts are exposed reliably by apps or the OS.

Future scanner work should separate:

- app menu shortcut discovery
- bundled and imported curated app mapping data
- user-imported/manual global hotkey data
- reserved macOS system shortcuts
