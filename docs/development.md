# Development

KeyScout is a native macOS Swift package.

## Requirements

- macOS 14 or newer
- Swift 6 / Xcode 26 or newer recommended

## Build

```sh
swift build
```

## Test

```sh
swift test
```

## Run

```sh
swift run KeyScout
```

KeyScout appears in the macOS menu bar as `⌘?`.

Use this command only for a quick launch smoke test. Accessibility permission is
bound to the running app identity. The SwiftPM debug binary launched by
`swift run` is not the same identity as the ad-hoc signed
`dist/KeyScout.app`, so granting Accessibility access to `KeyScout.app` will not
make `swift run KeyScout` trusted for scanning.

Use `Scan Frontmost App` to populate the `Scanned Shortcuts` submenu. The submenu
shows a compact limited view of the latest scan; export JSON to inspect the full
catalog. Built-in curated mappings are merged into the latest catalog when they
match the scanned app name or bundle identifier.

Use `Open Shortcut List` for a searchable native table with source filtering.
Use `Import Mapping JSON` to load a KeyScout catalog file into the local mapping
library. Imported mappings are stored at
`~/Library/Application Support/KeyScout/imported-mappings.json` and merge with
future scans by app name or bundle identifier.

Selecting a row in the shortcut list shows conflict detail for that shortcut,
including matching app, command, and source rows from the latest catalog.

During manual QA, remember that importing a mapping file does not populate the
list by itself unless the imported shortcuts match the current or future scanned
app name or bundle identifier. To test imported rows in the UI, scan a matching
app first or use a fixture whose app metadata matches the scanned app.

The exported catalog shape is documented in [json-schema.md](json-schema.md),
with a sample file at [examples/sample-catalog.json](examples/sample-catalog.json).

Reserved shortcut defaults are documented in
[reserved-shortcuts.md](reserved-shortcuts.md).

Known scanner and import limitations are documented in
[known-limitations.md](known-limitations.md).

## Local App Bundle

```sh
scripts/build_app.sh
open dist/KeyScout.app
```

The local app bundle is ad-hoc signed. It is useful for manual testing of menu
bar behavior and macOS permissions, but it is not a Developer ID signed or
notarized release artifact.

Use this bundle for Accessibility QA:

```sh
scripts/build_app.sh
open dist/KeyScout.app
```

## Accessibility Permission

Shortcut discovery uses macOS Accessibility APIs where possible. During manual
testing, macOS may ask for Accessibility permission so KeyScout can inspect app
menus. If permission is missing, the menu shows an Accessibility permission
message and an `Open Accessibility Settings` action.

When testing locally, grant permission to the ad-hoc signed
`/Users/tobias/Documents/Development/Keyscout/dist/KeyScout.app`, not to the
SwiftPM debug executable created by `swift run`.

The missing-permission path can be tested without granting access: launch
`dist/KeyScout.app`, open the `⌘?` menu, verify the permission message, choose
`Scan Frontmost App`, and confirm the status still reports that Accessibility
permission is needed. A full scan QA pass requires granting KeyScout
Accessibility access in System Settings.

## Reset Local Imported Mappings

Imported mappings are local-only Application Support data. To reset them during
development, quit KeyScout and remove:

```sh
rm -f ~/Library/Application\ Support/KeyScout/imported-mappings.json
```

## GitHub Workflow

KeyScout is open source. External contributors can fork the repository, push a
branch to their fork, and open a pull request against `main`.

Maintainers and project agents with write access should follow the detailed
workflow in [../AGENTS.md](../AGENTS.md). The short version is: work on a
branch, stage only relevant files, run `swift test`, use `gh` for PR creation
and merge, wait for the `Swift Build and Test` check, then squash-merge and
delete the branch. Do not commit or push directly to `main`.

Issue routing is automated by `.github/workflows/issue-triage.yml`. See
[triage.md](triage.md) for label behavior and maintainer review notes.
