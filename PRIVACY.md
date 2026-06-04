# Privacy

KeyScout is intended to be local-only.

## Data Model

KeyScout may need to inspect or store:

- App names
- App bundle identifiers
- Menu item names
- Keyboard shortcut combinations
- User-created shortcut snapshots
- Exported JSON mapping files
- Imported JSON mapping files

## Privacy Commitments

KeyScout should not:

- Track users
- Require accounts
- Upload shortcut data
- Upload app lists
- Run analytics
- Send telemetry
- Sell or share data

## Accessibility Permissions

KeyScout may need macOS Accessibility permissions to inspect app menus and discover shortcuts. The app checks whether this permission is available before scanning, explains when it is missing, and provides a menu action that opens macOS Accessibility settings. Users must still enable the permission manually in System Settings.

## Exports

JSON exports are user-owned files. Users are responsible for deciding whether exported shortcut data is safe to share publicly.

Imported JSON mappings are read from user-selected local files and kept local.
The current import flow stores merged imported mappings at
`~/Library/Application Support/KeyScout/imported-mappings.json` so they survive
app restarts. This file uses the documented local catalog JSON format and is not
uploaded by KeyScout.

## Future Changes

Any feature that introduces network access, sync, crash reporting, or diagnostics must update this document before it ships.
