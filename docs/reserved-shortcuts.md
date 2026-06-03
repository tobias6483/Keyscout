# Reserved Shortcuts

KeyScout skips a conservative set of common macOS and app-level shortcuts when
suggesting unused combinations. The goal is to avoid recommending shortcuts that
are widely expected to keep working, even when they were not discovered in the
latest app scan.

This list is not exhaustive. It is an initial default set that should grow as
KeyScout adds system shortcut awareness, imported mappings, and user-defined
blocked combinations.

## Categories

`ReservedShortcutDefaults` groups defaults into three categories:

- `appLifecycle`: common app lifecycle shortcuts such as quit, hide, minimize,
  and close window.
- `appSwitchingAndSystemUI`: common system UI shortcuts such as Spotlight, app
  switching, and force quit.
- `editingAndNavigation`: common document and editing shortcuts such as save,
  open, print, find, copy, paste, undo, and redo.

## Current Defaults

| Shortcut | Category | Reason |
| --- | --- | --- |
| `⌘H` | app lifecycle | Hide front app |
| `⌥⌘H` | app lifecycle | Hide other apps |
| `⌘M` | app lifecycle | Minimize window |
| `⌘Q` | app lifecycle | Quit app |
| `⌘W` | app lifecycle | Close window |
| `⌘Space` | app switching and system UI | Spotlight |
| `⌘Tab` | app switching and system UI | App switcher |
| `⌥⌘Esc` | app switching and system UI | Force quit |
| `⌃Space` | app switching and system UI | Input source switching on many systems |
| `⌘A` | editing and navigation | Select all |
| `⌘C` | editing and navigation | Copy |
| `⌘F` | editing and navigation | Find |
| `⌘G` | editing and navigation | Find next |
| `⇧⌘G` | editing and navigation | Find previous |
| `⌘N` | editing and navigation | New document/window |
| `⌘O` | editing and navigation | Open |
| `⌘P` | editing and navigation | Print |
| `⌘S` | editing and navigation | Save |
| `⇧⌘S` | editing and navigation | Save as / duplicate |
| `⌘V` | editing and navigation | Paste |
| `⌘X` | editing and navigation | Cut |
| `⌘Z` | editing and navigation | Undo |
| `⇧⌘Z` | editing and navigation | Redo |

## Future Work

Future reserved shortcut work should add:

- OS-version-aware system shortcut detection.
- User-defined blocked combinations.
- Imported launcher or automation tool shortcuts.
- Clear source labels for system, app, curated, manual, and user-blocked
  reservations.
