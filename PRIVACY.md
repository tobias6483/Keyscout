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

KeyScout may need macOS Accessibility permissions to inspect app menus and discover shortcuts. Those permissions should be requested only when needed, and the app should explain what it needs and why.

## Exports

JSON exports are user-owned files. Users are responsible for deciding whether exported shortcut data is safe to share publicly.

## Future Changes

Any feature that introduces network access, sync, crash reporting, or diagnostics must update this document before it ships.
