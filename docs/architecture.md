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
- `ShortcutGenerator` searches deterministic candidate combinations and skips
  known conflicts and reserved shortcuts.
- `ShortcutJSONStore` imports and exports catalog JSON.
- `ShortcutListPresenter` formats scanned shortcuts for compact menu display.

## Scanning

`AccessibilityShortcutScanner` uses macOS Accessibility APIs to inspect the
frontmost application's menu bar. This is intentionally best-effort because not
all shortcuts are exposed reliably by apps or the OS.

Future scanner work should separate:

- app menu shortcut discovery
- curated app mapping data
- user-imported/manual global hotkey data
- reserved macOS system shortcuts
